param(
	[Parameter(Mandatory=$false)]
	[string]$N = "bro"
)

# Import the SetWindowPos function from user32.dll
Add-Type -MemberDefinition @"
[DllImport("user32.dll")]
public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
"@ -Name "Win32" -Namespace "Win32Functions"

# Define some constants for the SetWindowPos function
$HWND_TOPMOST = [IntPtr]::Add([IntPtr]::Zero, -1) # Make the window topmost
# i dont think these two settings actually do anything?
$SWP_NOMOVE = 0x0002 # Keep the current position
$SWP_NOSIZE = 0x0001 # Keep the current size

# Get the msedge window with the window name set to "bro" (case sensitive)
$window_list = Get-Process -Name msedge | Where-Object { $_.MainWindowTitle -eq $N }

# Check if the window list is empty
if ($window_list.Count -eq 0) {
    # If there is no window named "bro", write a message to the user and exit
    Write-Host "Please name a window 'bro' and try again. or use the option '-N <window name>'"
    Exit
} else {
    # If there is a window named "bro", get the first one
    # i think Get-Process returns a list?
    $window = $window_list[0]

    # Set the window to be always on top
    [Win32Functions.Win32]::SetWindowPos($window.MainWindowHandle, $HWND_TOPMOST, 0, 0, 0, 0, $SWP_NOMOVE -bor $SWP_NOSIZE)
}