from abc import ABC, abstractmethod


class ICommand(ABC):

    @abstractmethod
    def execute(self):
        pass

    @abstractmethod
    def undo(self):
        pass


# Air conditioner Command
class AirConditionerOffCommand(ICommand):

    def __init__(self, _airConditioner):
        self.airConditioner = _airConditioner

    def execute(self):
        return self.airConditioner.off()

    def undo(self):
        self.airConditioner.on()


class AirConditionerOnCommand(ICommand):

    def __init__(self, _airConditioner):
        self.airConditioner = _airConditioner

    def execute(self):
        return self.airConditioner.on()

    def undo(self):
        self.airConditioner.off()


# Alarm Command
class AlarmOffCommand(ICommand):

    def __init__(self, _alarm):
        self.alarm = _alarm

    def execute(self):
        return self.alarm.off()

    def undo(self):
        self.alarm.on()


class AlarmOnCommand(ICommand):

    def __init__(self, _alarm):
        self.alarm = _alarm

    def execute(self):
        return self.alarm.on()

    def undo(self):
        self.alarm.off()


# Fridge Command
class FridgeOffCommand(ICommand):

    def __init__(self, _fridge):
        self.fridge = _fridge

    def execute(self):
        return self.fridge.off()

    def undo(self):
        self.fridge.on()


class FridgeOnCommand(ICommand):

    def __init__(self, _fridge):
        self.fridge = _fridge

    def execute(self):
        return self.fridge.on()

    def undo(self):
        self.fridge.off()


# Garage Door Command
class GarageDoorOffCommand(ICommand):

    def __init__(self, _garageDoor):
        self.garageDoor = _garageDoor

    def execute(self):
        return self.garageDoor.off()

    def undo(self):
        self.garageDoor.on()


class GarageDoorOnCommand(ICommand):

    def __init__(self, _garageDoor):
        self.garageDoor = _garageDoor

    def execute(self):
        return self.garageDoor.on()

    def undo(self):
        self.garageDoor.off()


# Gate Command
class GateOffCommand(ICommand):

    def __init__(self, _gate):
        self.gate = _gate

    def execute(self):
        return self.gate.off()

    def undo(self):
        self.gate.on()


class GateOnCommand(ICommand):

    def __init__(self, _gate):
        self.gate = _gate

    def execute(self):
        return self.gate.on()

    def undo(self):
        self.gate.off()


# Geyser Command
class GeyserOffCommand(ICommand):

    def __init__(self, _geyser):
        self.geyser = _geyser

    def execute(self):
        return self.geyser.off()

    def undo(self):
        self.geyser.on()


class GeyserOnCommand(ICommand):

    def __init__(self, _geyser):
        self.geyser = _geyser

    def execute(self):
        return self.geyser.on()

    def undo(self):
        self.geyser.off()


# Heater Command
class HeaterOffCommand(ICommand):

    def __init__(self, _heater):
        self.heater = _heater

    def execute(self):
        return self.heater.off()

    def undo(self):
        self.heater.on()


class HeaterOnCommand(ICommand):

    def __init__(self, _heater):
        self.heater = _heater

    def execute(self):
        return self.heater.on()

    def undo(self):
        self.heater.off()


# Light bulb Command
class LightBulbOffCommand(ICommand):

    def __init__(self, _lightbulb):
        self.lightbulb = _lightbulb

    def execute(self):
        return self.lightbulb.off()

    def undo(self):
        self.lightbulb.on()


class LightBulbOnCommand(ICommand):

    def __init__(self, _lightbulb):
        self.lightbulb = _lightbulb

    def execute(self):
        return self.lightbulb.on()

    def undo(self):
        self.lightbulb.off()


# PIR Command
class PIROffCommand(ICommand):

    def __init__(self, _pir):
        self.pir = _pir

    def execute(self):
        return self.pir.off()

    def undo(self):
        self.pir.on()


class PIROnCommand(ICommand):

    def __init__(self, _pir):
        self.pir = _pir

    def execute(self):
        return self.pir.on()

    def undo(self):
        self.pir.off()


# Sprinkler Command
class SprinklerOffCommand(ICommand):

    def __init__(self, _sprinkler):
        self.sprinkler = _sprinkler

    def execute(self):
        return self.sprinkler.off()

    def undo(self):
        self.sprinkler.on()


class SprinklerOnCommand(ICommand):

    def __init__(self, _sprinkler):
        self.sprinkler = _sprinkler

    def execute(self):
        return self.sprinkler.on()

    def undo(self):
        self.sprinkler.off()


# Stove Command
class StoveOffCommand(ICommand):

    def __init__(self, _stove):
        self.stove = _stove

    def execute(self):
        return self.stove.off()

    def undo(self):
        self.stove.on()


class StoveOnCommand(ICommand):

    def __init__(self, _stove):
        self.stove = _stove

    def execute(self):
        return self.stove.on()

    def undo(self):
        self.stove.off()


# Washing Machine Command
class WashingMachineOffCommand(ICommand):

    def __init__(self, _washingmachine):
        self.washingmachine = _washingmachine

    def execute(self):
        return self.washingmachine.off()

    def undo(self):
        self.washingmachine.on()


class WashingMachineOnCommand(ICommand):

    def __init__(self, _washingmachine):
        self.washingmachine = _washingmachine

    def execute(self):
        return self.washingmachine.on()

    def undo(self):
        self.washingmachine.off()


# This is to enable dynamic instantiation of classes using string names
concreteOn = {'Light Bulb': LightBulbOnCommand, 'Motion Detector': PIROnCommand, 'Air Conditioner': AirConditionerOnCommand,
                'Gate': GateOnCommand, 'Geyser': GeyserOnCommand, 'Heater': HeaterOnCommand, 'Sprinkler': SprinklerOnCommand,
                'Stove': StoveOnCommand, 'Garage Door': GarageDoorOnCommand, 'Fridge': FridgeOnCommand,
                'Washing Machine': WashingMachineOnCommand}

concreteOff = {'Light Bulb': LightBulbOffCommand, 'Motion Detector': PIROffCommand, 'Air Conditioner': AirConditionerOffCommand,
            'Gate': GateOffCommand, 'Geyser': GeyserOffCommand, 'Heater': HeaterOffCommand, 'Sprinkler': SprinklerOffCommand,
            'Stove': StoveOffCommand, 'Garage Door': GarageDoorOffCommand, 'Fridge': FridgeOffCommand,
            'Washing Machine': WashingMachineOffCommand}
