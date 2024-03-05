Add-Type -AssemblyName System.Windows.Forms
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class MouseMove {
        [DllImport("user32.dll")]
        public static extern bool SetCursorPos(int X, int Y);
    }
"@

# Function to move the mouse smoothly to a specific position
function Move-MouseSmoothly([int]$targetX, [int]$targetY, [int]$durationMilliseconds) {
    $currentX = [System.Windows.Forms.Cursor]::Position.X
    $currentY = [System.Windows.Forms.Cursor]::Position.Y
    $steps = 50  # Number of steps for smooth movement

    for ($i = 1; $i -le $steps; $i++) {
        $smoothX = $currentX + (($targetX - $currentX) * $i / $steps)
        $smoothY = $currentY + (($targetY - $currentY) * $i / $steps)
        $null = [MouseMove]::SetCursorPos($smoothX, $smoothY)
        Start-Sleep -Milliseconds ($durationMilliseconds / $steps)
    }
}

$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

# Main loop: repeat every 5 seconds
while ($true) {
    # Generate random X and Y coordinates within screen bounds
    $randomX = Get-Random -Minimum 0 -Maximum $screenWidth
    $randomY = Get-Random -Minimum 0 -Maximum $screenHeight

    # Move the mouse smoothly to the random position (duration: 500 milliseconds)
    Move-MouseSmoothly -targetX $randomX -targetY $randomY -durationMilliseconds 500

    # Sleep for 5 seconds
    Start-Sleep -Seconds 5
}