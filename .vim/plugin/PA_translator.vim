" Vim global plugin for translating unknown words, sentences
" Last Change:	2009 July 04
" Maintainer:	Pukalskyy Andrij <andrijpu@gmail.com>

" ensure that plugin is loaded just one time
if exists("g:PA_translator_version")
    finish
endif
let g:PA_translator_version = "0.0.3"

" check for Vim version 700 or greater
if v:version < 700
  echo "Sorry, PA_translator ".g:PA_translator_version."\nONLY runs with Vim 7.0 and greater."
  finish
endif

" plugin needs your vim was compiled with ruby support
if !has('ruby')
  echo "Sorry, PA_translator ".g:PA_translator_version."\nONLY runs if Vim was compiled with RUBY support."
  finish
endif

" save previous `cpo` value. it is necessary for `compatible` mode
let s:save_cpo = &cpo
set cpo&vim

" global script variables
if !exists("g:PA_translator_printed_in_encoding")
    let g:PA_translator_printed_in_encoding = &encoding
endif
if !exists("g:PA_translator_received_in_encoding")
    "let g:PA_translator_received_in_encoding = 'cp1251'
    let g:PA_translator_received_in_encoding = 'utf-8'
endif
if !exists("g:PA_translator_from_lang")
    let g:PA_translator_from_lang = 'en'
endif
if !exists("g:PA_translator_to_lang")
    let g:PA_translator_to_lang = 'uk'
endif

" should be initialized before 1-st translating actions
function! PA_init_translator()
ruby<<EOF
    require 'net/http'
    require 'cgi'
    require 'iconv'

    class PA_translator
        def initialize
            # we cann't request site by hostname, vim does not allow it, only by IP.
            # also we cann't IPSocket.getaddress, vim does not allow it too.
            # so, let's make a little hack and fetch it by `nslookup` command :)

            if RUBY_PLATFORM.downcase.include?("mswin")
                `nslookup translate.google.com`.match /Addresses:\s+(.*)\n/
                @ip = $1.split(', ')[0]
            else
                # `linux` and `freebsd` have a little bit different `nslookup` result format
                `nslookup translate.google.com`.match /Non-authoritative answer:.*?Address:\s+(.*?)$/m
                @ip = $1
            end

            # encoding convertor
            @encode_conv = Iconv.new(VIM::evaluate("g:PA_translator_printed_in_encoding"), VIM::evaluate("g:PA_translator_received_in_encoding"))
        end

        def translate_word(word)
            response = eval(Net::HTTP.get(@ip, "/translate_a/t?client=t&" <<
                                                "sl=#{VIM::evaluate('g:PA_translator_from_lang')}&" <<
                                                "tl=#{VIM::evaluate('g:PA_translator_to_lang')}&" <<
                                                "text=#{CGI.escape(word)}"))
            unless response.class == Array
                VIM::message("The `#{word}` can not be translated by `translate.google.com`")
            else
                VIM::message(@encode_conv.iconv(response[0]))
                VIM::message("=" * 50)
                response[1].each do |word_by_gender|
                    VIM::message(@encode_conv.iconv(word_by_gender[0]))
                    word_by_gender[1, word_by_gender.size].uniq.each {|word| VIM::message("    #{@encode_conv.iconv(word)}")}
                end
            end
        end

        def translate_sentence(sentence)
            response = eval(Net::HTTP.get(@ip, "/translate_a/t?client=t&" <<
                                                "sl=#{VIM::evaluate('g:PA_translator_from_lang')}&" <<
                                                "tl=#{VIM::evaluate('g:PA_translator_to_lang')}&" <<
                                                "text=#{CGI.escape(sentence)}"))
            VIM::message(@encode_conv.iconv(response))
        end
    end

    pa_translator = PA_translator.new
EOF
endfunction

" translate just 1 word under cursor in normal mode
function! PA_translate_word()
ruby<<EOF
    pa_translator.translate_word(VIM::evaluate("expand('<cword>')"))
EOF
endfunction

" translate selected sentence in visual mode
function! PA_translate_sentence()
ruby<<EOF
    pa_translator.translate_sentence(VIM::evaluate("substitute(@0, '\n', '', 'g')"))
EOF
endfunction


:call PA_init_translator()

let mapleader = ','
if !hasmapto('<Esc>:call<Space>PA_translate_word()<CR>')
    nnoremap <Leader>tr <Esc>:call<Space>PA_translate_word()<CR>|        " it translates 1 word in NORMAL mode
endif
if !hasmapto('Y<Esc>:call<Space>PA_translate_sentence()<CR>')
    vnoremap <Leader>tr Y<Esc>:call<Space>PA_translate_sentence()<CR>|   " it translates sentence selected or under cursor line in VISUAL mode
endif


" restore `cpo` value for other modules
let &cpo = s:save_cpo
