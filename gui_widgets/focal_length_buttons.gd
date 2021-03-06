# focal_length_buttons.gd
# This file is part of I, Voyager
# https://ivoyager.dev
# Copyright (c) 2017-2020 Charlie Whitfield
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# *****************************************************************************
# GUI widget. Expects the camera to have signal "focal_length_changed", member
# "focal_lengths" and function "increment_focal_length".

extends HBoxContainer

var _camera: Camera
onready var _fl_decr: Button = $Minus
onready var _fl_incr: Button = $Plus

func _ready():
	Global.connect("camera_ready", self, "_connect_camera")
	_fl_decr.connect("pressed", self, "_increment_focal_length", [-1])
	_fl_incr.connect("pressed", self, "_increment_focal_length", [1])
	_connect_camera(get_viewport().get_camera())

func _connect_camera(camera: Camera) -> void:
	if _camera != camera:
		_disconnect_camera()
		_camera = camera
		_camera.connect("focal_length_changed", self, "_update_focal_length")

func _disconnect_camera() -> void:
	if _camera and is_instance_valid(_camera):
		_camera.disconnect("focal_length_changed", self, "_update_focal_length")
	_camera = null

func _update_focal_length(focal_length: float) -> void:
	var focal_lengths: Array = _camera.focal_lengths
	_fl_decr.disabled = focal_length <= focal_lengths[0]
	_fl_incr.disabled = focal_length >= focal_lengths[-1]

func _increment_focal_length(increment: int) -> void:
	if _camera:
		_camera.increment_focal_length(increment)
