---
-- Example animation file
-- crafty by hand since im too lazy to build an editor at this point
--
{
	assets:
		building:
			file: 'coalplant_sheet.png'
			source_x: 1
			source_y: 1
			width: 176
			height: 96
		window_closed:
			file: 'coalplant_sheet.png'
			source_x: 177
			source_y: 1
			width: 11
			height: 11
		window_open:
			file: 'coalplant_sheet.png'
			source_x: 177
			source_y: 13
			width: 11
			height: 11
	animations:
		default:
			width: 176
			height: 96
			frames:
			{
				{
					assets:
					{
						{
							asset: 'building'
							x: 0
							y: 0
						}
						{
							asset: 'window_closed'
							x: 57
							y: 56
						}
						{
							asset: 'window_closed'
							x: 95
							y: 56
						}
						{
							asset: 'window_closed'
							x: 133
							y: 56
						}
						{
							asset: 'window_closed'
							x: 57
							y: 74
						}
						{
							asset: 'window_closed'
							x: 95
							y: 74
						}
						{
							asset: 'window_closed'
							x: 133
							y: 74
						}
					}
				}
			}
}