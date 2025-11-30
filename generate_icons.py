#!/usr/bin/env python3
"""Generate PWA icons for SmartResume"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_icon(size, output_path):
    """Create a simple icon with SR text"""
    # Create image with dark background
    img = Image.new('RGB', (size, size), color='#1f2937')
    draw = ImageDraw.Draw(img)
    
    # Draw a gradient-like effect with circles
    center = size // 2
    for i in range(5):
        radius = size // 2 - (i * size // 12)
        color_val = 31 + (i * 20)
        draw.ellipse(
            [center - radius, center - radius, center + radius, center + radius],
            fill=f'#{color_val:02x}{color_val + 10:02x}{color_val + 25:02x}'
        )
    
    # Draw SR text
    try:
        # Try to use a system font
        font_size = size // 3
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
    except:
        # Fallback to default font
        font = ImageFont.load_default()
    
    text = "SR"
    # Get text bounding box
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    # Center the text
    x = (size - text_width) // 2
    y = (size - text_height) // 2 - bbox[1]
    
    # Draw text with shadow
    draw.text((x+2, y+2), text, fill='#000000', font=font)
    draw.text((x, y), text, fill='#ffffff', font=font)
    
    # Save
    img.save(output_path, 'PNG')
    print(f"✓ Created {output_path}")

def main():
    output_dir = 'rails_app/public'
    os.makedirs(output_dir, exist_ok=True)
    
    # Generate icons
    create_icon(192, f'{output_dir}/icon-192.png')
    create_icon(512, f'{output_dir}/icon-512.png')
    create_icon(180, f'{output_dir}/apple-touch-icon.png')
    create_icon(32, f'{output_dir}/favicon-32x32.png')
    create_icon(16, f'{output_dir}/favicon-16x16.png')
    
    # Create a simple screenshot placeholder
    screenshot = Image.new('RGB', (1170, 2532), color='#111827')
    draw = ImageDraw.Draw(screenshot)
    try:
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 80)
    except:
        font = ImageFont.load_default()
    
    text = "SmartResume\nAI-Powered Resume Matching"
    bbox = draw.textbbox((0, 0), text, font=font)
    x = (1170 - (bbox[2] - bbox[0])) // 2
    y = 1000
    draw.text((x, y), text, fill='#ffffff', font=font, align='center')
    screenshot.save(f'{output_dir}/screenshot.png', 'PNG')
    print(f"✓ Created {output_dir}/screenshot.png")
    
    print("\n✅ All PWA icons generated successfully!")

if __name__ == '__main__':
    main()
