import time
import pygame
import os.path
from sys import exit
from json import load
from random import randint

debug = False

if os.path.exists("settings.json"):
    settings_file = open("settings.json")
    settings = load(settings_file)
    settings_file.close()

    resolution = settings["resolution"]
    fullscreen = settings["fullscreen"]
    flashing = settings["flashing"]
    music = settings["music"]
    sounds = settings["sounds"]
else:
    resolution = "1280x720"
    fullscreen = False
    flashing = True
    music = True
    sounds = True

fps = 100
clock = pygame.time.Clock()
res_x, res_y = resolution.split("x")
size = width, height = int(res_x), int(res_y)
screen = pygame.display.set_mode(size)
pygame.display.set_icon(pygame.image.load("assets/strawberry.png"))

if fullscreen:
    pygame.display.toggle_fullscreen()

pygame.init()
pygame.display.set_caption("Strawberry Catcher by hXR16F")

pygame.font.init()
debug_font = pygame.font.SysFont("Lucida Console", 15)
font = pygame.font.Font("assets/Acme-Regular.ttf", 75)
font_big = pygame.font.Font("assets/Acme-Regular.ttf", 100)
font_bigger = pygame.font.Font("assets/Acme-Regular.ttf", 120)

strawberry = pygame.image.load("assets/strawberry.png")
strawberry_rect = strawberry.get_rect()

mouth = pygame.image.load("assets/mouth.png")
mouth_rect = mouth.get_rect()
mouth_pos = [width / 2, height - 70]

if sounds:
    sound_eat = pygame.mixer.Sound("assets/eat.wav")
    sound_tick = pygame.mixer.Sound("assets/tick.wav")
    sound_lose = pygame.mixer.Sound("assets/lose.wav")
if music:
    sound_music = pygame.mixer.music.load("assets/music.ogg")
    pygame.mixer.music.set_volume(0.1)
    pygame.mixer.music.play(-1)


def pause(place):
    pygame.mouse.set_visible(True)
    pygame.event.set_grab(False)
    paused = True
    pygame.mixer.pause()
    pygame.mixer.music.pause()
    paused_text = font_bigger.render("Paused", True, (255, 255, 255))
    if place == "default":
        screen.blit(
            paused_text, (
                width / 2 - paused_text.get_width() / 2,
                height / 2 - paused_text.get_height() / 2
            )
        )
    elif place == "timer":
        screen.blit(
            paused_text, (
                width / 2 - paused_text.get_width() / 2,
                height / 2 - paused_text.get_height() / 2 - height / 4
            )
        )

    pygame.display.update()
    while 1:
        time.sleep(0.001)  # Reduce CPU usage when paused
        if paused == True:
            for event2 in pygame.event.get():
                if event2.type == pygame.QUIT:
                    exit()
                elif event2.type == pygame.KEYDOWN:
                    paused = False
                    pygame.mouse.set_visible(False)
                    pygame.event.set_grab(True)
                    break
        else:
            break

    pygame.mixer.unpause()
    pygame.mixer.music.unpause()
    return


while 1:
    bg = 30, 30, 30
    black = 0, 0, 0
    points = 0
    speed = 1
    lose = False
    paused = False
    faded_lose = False
    if flashing:
        fade_start = False
        fade_start_col = 30
        fade_start_bg_col = fade_start_col, fade_start_col, fade_start_col

    timer_started = True
    restart = False

    strawberry_pos = [
        randint(
            strawberry.get_rect().size[0], width - strawberry.get_rect().size[0]
        ), 0 - strawberry.get_rect().size[1]
    ]

    pygame.mouse.set_visible(False)
    pygame.event.set_grab(True)

    while 1:
        if restart:
            break

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                exit()
            elif event.type == pygame.KEYDOWN:
                pause("default")

        if lose:
            if sounds:
                sound_lose.stop()
                sound_lose.play()
            lose_text = font_bigger.render("You lose!", True, (255, 255, 255))
            screen.fill(bg)
            screen.blit(
                lose_text, (
                    width / 2 - lose_text.get_width() / 2,
                    height / 2 - lose_text.get_height() / 2
                )
            )
            if faded_lose == False:
                faded_lose = True
                for i in range(255, 0, -5):
                    col = i, i, i
                    screen.fill(col)
                    pygame.display.update()
                    clock.tick(fps)

            pygame.display.update()
            clock.tick(fps)
            restart = True
        elif timer_started:
            for i in range(3, 0, -1):
                timer_text = font_bigger.render(str(i), True, (255, 255, 255))
                timer_end_time = pygame.time.get_ticks() + 1000
                screen.fill(bg)
                screen.blit(
                    timer_text, (
                        width / 2 - timer_text.get_width() / 2,
                        height / 2 - timer_text.get_height() / 2
                    )
                )
                if sounds:
                    sound_tick.stop()
                    sound_tick.play()
                pygame.display.update()
                clock.tick(fps)
                while 1:
                    current_time = pygame.time.get_ticks()
                    for event in pygame.event.get():
                        if event.type == pygame.QUIT:
                            exit()
                        elif event.type == pygame.KEYDOWN:
                            pause("timer")
                    if current_time > timer_end_time:
                        break

            screen.fill(bg)
            timer_started = False

        else:
            mouse_x, mouse_y = pygame.mouse.get_pos()
            mouth_pos = mouse_x - mouth.get_rect().size[0] / 2, height - 200

            strawberry_pos[1] += 5 + (1 * points / 4)

            if flashing:
                if fade_start:
                    if fade_start_col <= 30:
                        fade_start = False
                        fade_start_col = 36
                    else:
                        fade_start_col -= 0.18
                        fade_start_bg_col = fade_start_col, fade_start_col, fade_start_col

            if strawberry_pos[1] > height:
                lose = True
                pygame.mouse.set_visible(True)
                pygame.event.set_grab(False)
            elif strawberry_pos[1] > height - 200 and strawberry_pos[1] < height - 80:
                if (
                    strawberry_pos[0] + float(strawberry.get_rect().size[0] / 2) + 20
                ) > mouth_pos[0] and (
                    strawberry_pos[0] + float(strawberry.get_rect().size[0] / 2) - 20
                ) < (
                    mouth_pos[0] + float(mouth.get_rect().size[0])
                ):
                    if sounds:
                        sound_eat.stop()
                        sound_eat.play()
                    points += 1
                    if flashing:
                        fade_start = True
                        fade_start_col = 36
                    strawberry_pos = [
                        randint(
                            strawberry.get_rect().size[0],
                            width - strawberry.get_rect().size[0]
                        ), 0 - strawberry.get_rect().size[1]
                    ]

            if debug:
                mouth_pos_text = str(mouth_pos)
                textsurface = debug_font.render(
                    "mouth_pos = " + mouth_pos_text, True, (255, 255, 255)
                )
                strawberry_pos_text = str(strawberry_pos)
                textsurface2 = debug_font.render(
                    "strawberry_pos = " + strawberry_pos_text, True, (255, 255, 255)
                )
                textsurface3 = debug_font.render(
                    "speed = " + str(5 + (1 * points / 4)), True, (255, 255, 255)
                )
                textsurface4 = debug_font.render(
                    "fade_start_bg_col = " + str(fade_start_bg_col), True, (255, 255, 255)
                )

            points_text = font.render("Points: " + str(points), True, (255, 255, 255))

            if flashing:
                if fade_start:
                    screen.fill(fade_start_bg_col)
                else:
                    screen.fill(bg)
            else:
                screen.fill(bg)

            screen.blit(strawberry, strawberry_pos)
            screen.blit(mouth, mouth_pos)

            if debug:
                screen.blit(textsurface, (40, 40))
                screen.blit(textsurface2, (40, 60))
                screen.blit(textsurface3, (40, 80))
                screen.blit(textsurface4, (40, 100))

            screen.blit(points_text, (width / 2 - points_text.get_width() / 2, height / 6))

            pygame.display.update()
            clock.tick(fps)
