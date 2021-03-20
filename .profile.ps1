# Put this into: $ notepad $profile

Set-PSReadlineOption -BellStyle None
#Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineOption -EditMode Vi #this is sparta!
Set-PSReadlineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory
