#!/usr/bin/env python3
"""
Flutech için özel favicon ve ikon oluşturucu
Modern, tech-friendly tasarım
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_flutech_icon(size, output_path):
    """Flutech için özel ikon oluştur"""
    # Modern gradient background
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Gradient background (dark blue to purple)
    for i in range(size):
        # Gradient from dark blue (#1a237e) to purple (#4a148c)
        ratio = i / size
        r = int(26 + (74 - 26) * ratio)
        g = int(35 + (20 - 35) * ratio)
        b = int(126 + (140 - 126) * ratio)
        draw.line([(0, i), (size, i)], fill=(r, g, b, 255))
    
    # Add rounded corners
    mask = Image.new('L', (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    corner_radius = size // 6
    mask_draw.rounded_rectangle(
        [(0, 0), (size, size)], 
        radius=corner_radius, 
        fill=255
    )
    
    # Apply mask for rounded corners
    result = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    result.paste(img, (0, 0))
    result.putalpha(mask)
    
    # Add "F" letter in modern style
    try:
        # Try to use a modern font, fallback to default if not available
        try:
            font_size = size // 2
            font = ImageFont.truetype("arial.ttf", font_size)
        except:
            font = ImageFont.load_default()
    except:
        font = ImageFont.load_default()
    
    # Draw "F" letter
    letter = "F"
    
    # Get text bounding box for centering
    bbox = draw.textbbox((0, 0), letter, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    x = (size - text_width) // 2
    y = (size - text_height) // 2 - size // 20  # Slightly up
    
    # Draw text shadow
    shadow_offset = max(1, size // 64)
    draw.text((x + shadow_offset, y + shadow_offset), letter, 
              fill=(0, 0, 0, 100), font=font)
    
    # Draw main text in white
    draw.text((x, y), letter, fill=(255, 255, 255, 255), font=font)
    
    # Add subtle glow effect
    glow = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow)
    
    # Multiple glow layers
    for offset in range(1, max(2, size // 32)):
        alpha = max(10, 60 - offset * 15)
        glow_draw.text((x - offset, y), letter, fill=(255, 255, 255, alpha), font=font)
        glow_draw.text((x + offset, y), letter, fill=(255, 255, 255, alpha), font=font)
        glow_draw.text((x, y - offset), letter, fill=(255, 255, 255, alpha), font=font)
        glow_draw.text((x, y + offset), letter, fill=(255, 255, 255, alpha), font=font)
    
    # Blend glow with main image
    result = Image.alpha_composite(result, glow)
    
    # Draw main text again to make it crisp
    final_draw = ImageDraw.Draw(result)
    final_draw.text((x, y), letter, fill=(255, 255, 255, 255), font=font)
    
    # Save the image
    result.save(output_path, 'PNG', quality=100)
    print(f"Created icon: {output_path} ({size}x{size})")

def main():
    """Ana fonksiyon"""
    print("🚀 Flutech ikonları oluşturuluyor...")
    
    # Ikon boyutları
    sizes = [
        (16, "favicon.ico"),
        (32, "favicon-32x32.png"),
        (192, "icons/Icon-192.png"),
        (512, "icons/Icon-512.png"),
        (192, "icons/Icon-maskable-192.png"),
        (512, "icons/Icon-maskable-512.png")
    ]
    
    # Web dizini
    web_dir = os.path.dirname(os.path.abspath(__file__))
    
    for size, filename in sizes:
        output_path = os.path.join(web_dir, filename)
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        create_flutech_icon(size, output_path)
    
    print("✅ Tüm ikonlar başarıyla oluşturuldu!")
    print("🎨 Modern Flutech tasarımı ile favicon ve app ikonları hazır!")

if __name__ == "__main__":
    main()