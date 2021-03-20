# Put this into: $ notepad $profile

# If powershell outputs an error execute any of the following commands from a privileged shell:
# $ Set-ExecutionPolicy Unrestricted
# $ Set-ExecutionPolicy RemoteSigned 

Set-PSReadlineOption -BellStyle None
#Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineOption -EditMode Vi #this is sparta!
Set-PSReadlineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory
