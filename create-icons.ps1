# Flutech Favicon Creator - PowerShell Script
Add-Type -AssemblyName System.Drawing

function Create-FlutechIcon {
    param(
        [int]$Size,
        [string]$OutputPath
    )
    
    # Create bitmap
    $bitmap = New-Object System.Drawing.Bitmap($Size, $Size)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    
    # Create gradient brush
    $startColor = [System.Drawing.Color]::FromArgb(255, 26, 35, 126)    # #1a237e
    $endColor = [System.Drawing.Color]::FromArgb(255, 74, 20, 140)      # #4a148c
    $gradientBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        [System.Drawing.Point]::new(0, 0),
        [System.Drawing.Point]::new($Size, $Size),
        $startColor,
        $endColor
    )
    
    # Draw rounded rectangle background
    $rect = New-Object System.Drawing.Rectangle(0, 0, $Size, $Size)
    $radius = [math]::Floor($Size * 0.15)
    
    # Create rounded rectangle path
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc($rect.X, $rect.Y, $radius * 2, $radius * 2, 180, 90)
    $path.AddArc($rect.Right - $radius * 2, $rect.Y, $radius * 2, $radius * 2, 270, 90)
    $path.AddArc($rect.Right - $radius * 2, $rect.Bottom - $radius * 2, $radius * 2, $radius * 2, 0, 90)
    $path.AddArc($rect.X, $rect.Bottom - $radius * 2, $radius * 2, $radius * 2, 90, 90)
    $path.CloseFigure()
    
    # Fill background
    $graphics.FillPath($gradientBrush, $path)
    
    # Draw "F" letter
    $fontSize = [math]::Floor($Size * 0.6)
    $font = New-Object System.Drawing.Font("Arial", $fontSize, [System.Drawing.FontStyle]::Bold)
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    
    # Center text
    $text = "F"
    $stringFormat = New-Object System.Drawing.StringFormat
    $stringFormat.Alignment = [System.Drawing.StringAlignment]::Center
    $stringFormat.LineAlignment = [System.Drawing.StringAlignment]::Center
    
    $textRect = New-Object System.Drawing.RectangleF(0, 0, $Size, $Size)
    $graphics.DrawString($text, $font, $brush, $textRect, $stringFormat)
    
    # Save image
    $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    
    # Cleanup
    $graphics.Dispose()
    $bitmap.Dispose()
    $gradientBrush.Dispose()
    $brush.Dispose()
    $font.Dispose()
    
    Write-Host "Created icon: $OutputPath ($Size x $Size)" -ForegroundColor Green
}

# Create icons
Write-Host "🚀 Creating Flutech icons..." -ForegroundColor Cyan

$webDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Create icons directory if it doesn't exist
$iconsDir = Join-Path $webDir "icons"
if (!(Test-Path $iconsDir)) {
    New-Item -ItemType Directory -Path $iconsDir -Force
}

# Icon configurations
$icons = @(
    @{ Size = 16; Path = "favicon.png" },
    @{ Size = 32; Path = "favicon-32x32.png" },
    @{ Size = 192; Path = "icons\Icon-192.png" },
    @{ Size = 512; Path = "icons\Icon-512.png" },
    @{ Size = 192; Path = "icons\Icon-maskable-192.png" },
    @{ Size = 512; Path = "icons\Icon-maskable-512.png" }
)

foreach ($icon in $icons) {
    $fullPath = Join-Path $webDir $icon.Path
    Create-FlutechIcon -Size $icon.Size -OutputPath $fullPath
}

Write-Host "✅ All Flutech icons created successfully!" -ForegroundColor Green
Write-Host "🎨 Modern tech design with gradient background and 'F' logo ready!" -ForegroundColor Yellow