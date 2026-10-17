@tool
extends Resource
class_name CreditsContent

@export var sections: Array[CreditsSection]

func is_empty() -> bool:
	return sections.is_empty()


func populate_bbtext(rtl: RichTextLabel) -> void:
	if not rtl:
		print('Warning: no rtl available at this time, skipping bbtext population')
		return

	rtl.text = ""
	rtl.push_outline_color(Color.from_hsv(0,0,0.1,0.8))
	rtl.push_outline_size(4)
	rtl.push_font_size(16)
	rtl.append_text("[center]")

	for section: CreditsSection in sections:
		push_section(rtl, section)

	rtl.pop_all()


func push_section(rtl: RichTextLabel, section: CreditsSection) -> void:
	push_title(rtl, section.title)
	match section.type:
		CreditsSection.Type.single_main:
			for block: CreditsBlock in section.blocks:
				rtl.push_context()
				rtl.append_text(block.main)
				rtl.append_text("\n")
				rtl.pop_context()
		CreditsSection.Type.l1_rN:
			rtl.push_context()
			rtl.push_table(3)
			for block: CreditsBlock in section.blocks:
				push_cell(rtl, block.main, 'right')
				push_cell(rtl, '   ')
				push_cell(rtl, block.secondary.front(), 'left')
				
				for right in block.secondary.slice(1):
					push_cell(rtl, '')
					push_cell(rtl, '')
					push_cell(rtl, right, 'left')
				
				var is_last_block = block == section.blocks.back()
				if not is_last_block:
					push_cell(rtl, ' ')
					push_cell(rtl, ' ')
					push_cell(rtl, ' ')
			rtl.pop_context()
	rtl.append_text("\n".repeat(3))

func push_title(rtl: RichTextLabel, value: String) -> void:
	rtl.push_context()
	rtl.push_font_size(24)
	rtl.push_underline()
	rtl.append_text(value)
	rtl.append_text("\n".repeat(2))
	rtl.pop_context()

func push_cell(rtl: RichTextLabel, text: String, align: String = ''):
	rtl.push_cell()
	match align:
		'left':
			rtl.push_paragraph(HORIZONTAL_ALIGNMENT_LEFT)
		'right':
			rtl.push_paragraph(HORIZONTAL_ALIGNMENT_RIGHT)
		_:
			rtl.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER)
	rtl.append_text(text)
	rtl.pop()
	rtl.pop()
	
