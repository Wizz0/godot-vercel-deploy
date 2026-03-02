extends Sprite2D

var speed = 400

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	# Управление стрелочками
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	# Нормализуем диагональное движение
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	# Применяем движение
	position += velocity * delta
	
	# Простая анимация - вращение при движении
	if velocity.length() > 0:
		rotation += velocity.length() * delta * 0.01
