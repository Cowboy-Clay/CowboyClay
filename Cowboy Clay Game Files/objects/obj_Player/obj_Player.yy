{
  "spriteId": {
    "name": "spr_SwordIdle",
    "path": "sprites/spr_SwordIdle/spr_SwordIdle.yy",
  },
  "solid": false,
  "visible": true,
  "spriteMaskId": {
    "name": "spr_Guy",
    "path": "sprites/spr_Guy/spr_Guy.yy",
  },
  "persistent": false,
  "parentObjectId": null,
  "physicsObject": false,
  "physicsSensor": false,
  "physicsShape": 1,
  "physicsGroup": 1,
  "physicsDensity": 0.5,
  "physicsRestitution": 0.1,
  "physicsLinearDamping": 0.1,
  "physicsAngularDamping": 0.1,
  "physicsFriction": 0.2,
  "physicsStartAwake": true,
  "physicsKinematic": false,
  "physicsShapePoints": [],
  "eventList": [
    {"isDnD":false,"eventNum":0,"eventType":0,"collisionObjectId":null,"resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMEvent",},
    {"isDnD":false,"eventNum":0,"eventType":3,"collisionObjectId":null,"resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMEvent",},
    {"isDnD":false,"eventNum":2,"eventType":3,"collisionObjectId":null,"resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMEvent",},
    {"isDnD":false,"eventNum":7,"eventType":7,"collisionObjectId":null,"resourceVersion":"1.0","name":"","tags":[],"resourceType":"GMEvent",},
  ],
  "properties": [
    {"varType":0,"value":"0.9","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"frict_value","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":0,"value":"1","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"h_accel","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":0,"value":"30","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"jump_accel","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":0,"value":"0.95","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"grav","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":0,"value":"20","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"max_velocity","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":0,"value":"160","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"max_gravity","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":0,"value":"160","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"max_vertical_velocity","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":1,"value":"20","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"jump_buffer","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":1,"value":"0","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"jump_buffer_counter","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":3,"value":"False","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"attacking","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":3,"value":"0","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"invin","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":1,"value":"0","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"invin_timer","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":3,"value":"True","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"armed","tags":[],"resourceType":"GMObjectProperty",},
    {"varType":3,"value":"0","rangeEnabled":false,"rangeMin":0.0,"rangeMax":10.0,"listItems":[],"multiselect":false,"filters":[],"resourceVersion":"1.0","name":"attack_disallowed","tags":[],"resourceType":"GMObjectProperty",},
  ],
  "overriddenProperties": [],
  "parent": {
    "name": "Objects",
    "path": "folders/Objects.yy",
  },
  "resourceVersion": "1.0",
  "name": "obj_Player",
  "tags": [],
  "resourceType": "GMObject",
}