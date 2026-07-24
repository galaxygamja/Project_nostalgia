extends Control

const BootstrapScript = preload("res://scripts/data/data_bootstrap.gd")
const SessionFactoryScript = preload("res://scripts/runtime/runtime_session_factory.gd")

var loop: GameLoopV1
var status_label: Label
var document_label: RichTextLabel
var evidence_label: RichTextLabel
var schedule_label: RichTextLabel
var operation_label: RichTextLabel
var choice_box: VBoxContainer
var action_box: VBoxContainer
var assignee_picker: OptionButton


func _ready() -> void:
	_build_layout()
	var bootstrap := BootstrapScript.new()
	bootstrap.data_root = _get_data_root_from_arguments()
	add_child(bootstrap)
	var boot_result := bootstrap.bootstrap()
	if not boot_result.get("ok", false):
		status_label.text = "데이터 초기화 실패 — 출력 기록을 확인하십시오."
		return
	var session_result := SessionFactoryScript.new().create_session(bootstrap.repository)
	if not session_result.get("ok", false):
		status_label.text = "운영 세션 생성 실패: %s" % session_result.get("reason", "unknown")
		return
	loop = session_result.loop
	loop.encounter_required.connect(func(_payload): _render())
	loop.game_ended.connect(func(_result): _render())
	_render()


func _build_layout() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var background := ColorRect.new()
	background.color = Color("151713")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 36)
	margin.add_theme_constant_override("margin_top", 28)
	margin.add_theme_constant_override("margin_right", 36)
	margin.add_theme_constant_override("margin_bottom", 28)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(margin)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 14)
	margin.add_child(root)
	status_label = Label.new()
	status_label.add_theme_font_size_override("font_size", 22)
	status_label.add_theme_color_override("font_color", Color("d4d0bf"))
	root.add_child(status_label)
	var columns := HBoxContainer.new()
	columns.size_flags_vertical = Control.SIZE_EXPAND_FILL
	columns.add_theme_constant_override("separation", 18)
	root.add_child(columns)
	var evidence := _paper_panel("대조 자료")
	evidence.custom_minimum_size.x = 410
	columns.add_child(evidence)
	evidence_label = _rich_text()
	evidence.add_child(evidence_label)
	var center := _paper_panel("현재 기록")
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	columns.add_child(center)
	document_label = _rich_text()
	document_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	center.add_child(document_label)
	choice_box = VBoxContainer.new()
	choice_box.add_theme_constant_override("separation", 8)
	center.add_child(choice_box)
	var side := _paper_panel("일정 · 배정")
	side.custom_minimum_size.x = 430
	columns.add_child(side)
	assignee_picker = OptionButton.new()
	side.add_child(assignee_picker)
	schedule_label = _rich_text()
	schedule_label.custom_minimum_size.y = 260
	side.add_child(schedule_label)
	action_box = VBoxContainer.new()
	action_box.add_theme_constant_override("separation", 6)
	side.add_child(action_box)
	operation_label = _rich_text()
	operation_label.custom_minimum_size.y = 150
	side.add_child(operation_label)


func _paper_panel(title: String) -> VBoxContainer:
	var panel := VBoxContainer.new()
	panel.add_theme_constant_override("separation", 10)
	var heading := Label.new()
	heading.text = title
	heading.add_theme_font_size_override("font_size", 18)
	heading.add_theme_color_override("font_color", Color("6f251d"))
	panel.add_child(heading)
	var line := HSeparator.new()
	panel.add_child(line)
	return panel


func _rich_text() -> RichTextLabel:
	var label := RichTextLabel.new()
	label.bbcode_enabled = true
	label.fit_content = false
	label.scroll_active = true
	label.add_theme_font_size_override("normal_font_size", 18)
	label.add_theme_color_override("default_color", Color("d4d0bf"))
	return label


func _render() -> void:
	if loop == null:
		return
	var state := loop.game_state
	status_label.text = "D+%d  %02d:%02d  |  책임자 기록대" % [state.get_day(), state.get_hour(), state.get_minute()]
	_render_assignees(state)
	_render_evidence(state)
	_render_schedule(state)
	_render_document(state)
	_render_actions()
	_render_operation_record(state)


func _render_assignees(state: GameState) -> void:
	assignee_picker.clear()
	for id in state.characters.keys():
		var definition := loop.repository.get_data(str(id))
		var state_data: Dictionary = state.characters[id]
		assignee_picker.add_item("%s — %s" % [definition.get("name", id), "가용" if state_data.get("available", false) else "업무 불가"])
		assignee_picker.set_item_metadata(assignee_picker.item_count - 1, id)


func _render_evidence(state: GameState) -> void:
	var lines := ["[color=#9cab8b]전자 보고[/color]\n정수량: 안정적으로 기록됨.", "\n[color=#d2b48c]종이 장부[/color]\n같은 시간대의 수치가 더 낮게 적혀 있음.", "\n[color=#d0d0d0]현장 관찰[/color]\n정수 설비의 압력계가 간헐적으로 흔들림."]
	if "LXXX_001" in state.clue_ids: lines.append("\n• 상충하는 정수 기록 확보")
	if "LXXX_002" in state.clue_ids: lines.append("\n• 외부 중계기 장치 확보")
	evidence_label.text = "\n".join(lines)


func _render_schedule(state: GameState) -> void:
	var lines := ["[b]현재 배정[/b]"]
	for schedule in state.fixed_schedules:
		if not bool(schedule.get("completed", false)) and int(schedule.get("start_slot", -1)) >= state.current_slot:
			var delegate := str(state.schedule_delegates.get(str(schedule.id), ""))
			var name := "책임자"
			if not delegate.is_empty(): name = str(loop.repository.get_data(delegate).get("name", delegate))
			lines.append("• %02d:%02d %s — %s" % [int(schedule.start_slot) % state.slots_per_day * state.minutes_per_slot / 60, int(schedule.start_slot) % state.slots_per_day * state.minutes_per_slot % 60, schedule.source_schedule_id, name])
	schedule_label.text = "\n".join(lines)


func _render_document(state: GameState) -> void:
	for child in choice_box.get_children(): child.queue_free()
	if loop.phase == GameLoopV1.Phase.RESOLVING_ENCOUNTER:
		var encounter: Dictionary = loop.pending_encounter.encounter
		var pages: Array = encounter.get("pages", [])
		var text := "[b]%s[/b]\n\n" % encounter.get("name", "기록")
		for page in pages: text += "%s\n\n" % page.get("text", "")
		document_label.text = text
		var choices: Array = encounter.get("choices", [])
		if choices.is_empty():
			_add_button(choice_box, "기록을 닫는다", func(): _run_result(loop.resolve_encounter()))
		else:
			for choice in choices:
				_add_button(choice_box, str(choice.get("text", "선택")), func(): _run_result(loop.resolve_encounter(str(choice.get("choice_id", "")))))
	elif loop.phase == GameLoopV1.Phase.GAME_OVER:
		document_label.text = "[b]운영 기록[/b]\n사흘간의 기록이 정리되었다. 원인은 아직 확정되지 않았다."
	else:
		document_label.text = "[b]다음 판단[/b]\n증거를 대조하고, 업무를 배정하거나 직접 수행한다."


func _render_actions() -> void:
	for child in action_box.get_children(): child.queue_free()
	if loop.phase != GameLoopV1.Phase.AWAITING_ACTION: return
	_add_button(action_box, "기지 관리", func(): _run_result(loop.select_action("AXXX_001", _selected_assignee())))
	_add_button(action_box, "수면 2시간", func(): _run_result(loop.select_action("AXXX_002", loop.game_state.commander_id, 4)))
	for task in loop.get_available_tasks(): _add_button(action_box, "%s 배정" % task.name, func(): _run_result(loop.select_task(task.id, _selected_assignee())))
	for deduction in loop.get_available_deductions(): _add_button(action_box, "%s 검토" % deduction.name, func(): _run_result(loop.start_deduction(deduction.id)))
	for schedule in loop.game_state.fixed_schedules:
		if bool(schedule.get("delegate_allowed", false)) and not bool(schedule.get("completed", false)):
			_add_button(action_box, "%s 위임" % schedule.source_schedule_id, func(): _run_result(loop.assign_schedule_delegate(schedule.id, _selected_assignee())))


func _render_operation_record(state: GameState) -> void:
	var lines := ["[b]업무 흔적[/b]"]
	for entry in state.operation_log.slice(maxi(0, state.operation_log.size() - 5)):
		lines.append("• %s" % entry.type)
	operation_label.text = "\n".join(lines)


func _selected_assignee() -> String:
	return str(assignee_picker.get_item_metadata(assignee_picker.selected))


func _add_button(parent: Control, text: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.focus_mode = Control.FOCUS_ALL
	button.pressed.connect(callback)
	parent.add_child(button)


func _run_result(result: Dictionary) -> void:
	if not result.get("ok", false):
		status_label.text = "처리 불가: %s" % result.get("reason", "unknown")
	_render()


func _get_data_root_from_arguments() -> String:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--data-root="): return argument.trim_prefix("--data-root=")
	return "res://data"
