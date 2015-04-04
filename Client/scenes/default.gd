
extends Node2D

var webClient = preload("res://scripts/httpClient.gd")

var labelNode
var timerNode

var web
var update_url

func _ready():
	# Initialization here
	
	labelNode = get_node("Label");
	timerNode = get_node("Timer")
	
	web = webClient.new()
	web.get("http://GAMESERVER:8080/headless/get_token/password", self, "on_init_server")

func on_init_server(data):
	var d = {}
	var err = d.parse_json(data)
	if (err == OK):
		update_url = d["fetch_url"];
		timerNode.start()
	




func _on_Timer_timeout():
	timerNode.stop()
	web = webClient.new()
	web.get(update_url, self, "on_fetch_server")
	
func on_fetch_server(data):
	var d = {}
	var err = d.parse_json(data)
	if (err == OK):
		labelNode.set_text("Status: " + d["status"] + "\r\n" + "Time:" + str(d["time"]));
	
	timerNode.start()