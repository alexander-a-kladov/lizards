#!/usr/bin/python3
import sys
from array import array

import math as m
import pygame
import moderngl

pygame.init()

SCR_SIZE=1000
DEG_RAD=(3.1415926535 / 180.0)

screen = pygame.display.set_mode((SCR_SIZE, SCR_SIZE), pygame.OPENGL | pygame.DOUBLEBUF)
display = pygame.Surface((SCR_SIZE, SCR_SIZE))
ctx = moderngl.create_context()

clock = pygame.time.Clock()

quad_buffer = ctx.buffer(data=array('f', [
    # position (x, y), uv coords (x, y)
    -1.0, 1.0, 0.0, 0.0,  # topleft
    1.0, 1.0, 1.0, 0.0,   # topright
    -1.0, -1.0, 0.0, 1.0, # bottomleft
    1.0, -1.0, 1.0, 1.0 # bottomright
]))

render_object = None

vert_shader = '''
#version 430 core

in vec2 vert;
in vec2 texcoord;
out vec2 uvs;

void main() {
    uvs = texcoord;
    gl_Position = vec4(vert, 0.0, 1.0);
}
'''

def surf_to_texture(surf):
    tex = ctx.texture(surf.get_size(), 4)
    tex.filter = (moderngl.LINEAR, moderngl.LINEAR)
    tex.swizzle = 'BGRA'
    tex.write(surf.get_view('1'))
    return tex

def rotate2D(dxdy, a):
    s = m.sin(a);
    c = m.cos(a);
    return (dxdy[0]*c-dxdy[1]*s, dxdy[0]*s+dxdy[1]*c);
    
class ScreenData():
    def __init__(self):
        self.speed = 0.0
        self.angle = 0.0
        self.zoom_speed = 0.0
        self.MAX_SPEED = 180.0
        self.MAX_ZOOM_SPEED = 2500
        self.MAX_ZOOM = 10.0
        self.MIN_ZOOM = 0.1
        self.MAX_CYCLES = 1000
        self.zoom = 1.0
        self.dx = 0.0
        self.dy = 0.0
        self.dx_g = 1.0
        self.dy_g = 0.5
        self.s_dx = 0.0
        self.s_dy = 0.0
        self.s_dx_g = 0.0
        self.s_dy_g = 0.0
        self.speed = 0.0
        self.X_M_MAX = 3.0
        self.X_M_MIN = 1.0
        self.x_m = 1.860
        self.cycles = self.MAX_CYCLES
        
    def readEvents(self):
        redraw = False
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_LEFT:
                    if self.speed < self.MAX_SPEED:
                        self.speed += 0.5
                    redraw = True
                elif event.key == pygame.K_RIGHT:
                    if self.speed > -self.MAX_SPEED:
                        self.speed -= 0.5
                    redraw = True
                elif event.key == pygame.K_DOWN:
                    if self.zoom_speed < self.MAX_ZOOM_SPEED:
                        self.zoom_speed += 0.01
                    redraw = True
                elif event.key == pygame.K_UP:
                    if self.zoom_speed > -self.MAX_ZOOM_SPEED:
                        self.zoom_speed -= 0.01
                    redraw = True
                if event.key == pygame.K_a:
                    self.s_dx -= 5.0
                    redraw = True
                elif event.key == pygame.K_d:
                    self.s_dx += 5.0
                    redraw = True
                elif event.key == pygame.K_w:
                    self.s_dy += 5.0
                    redraw = True
                elif event.key == pygame.K_s:
                    self.s_dy -= 5.0
                    redraw = True
                if event.key == pygame.K_c:
                    self.s_dx_g -= 0.01
                    redraw = True
                elif event.key == pygame.K_b:
                    self.s_dx_g += 0.01
                    redraw = True
                elif event.key == pygame.K_g:
                    self.s_dy_g += 0.01
                    redraw = True
                elif event.key == pygame.K_v:
                    self.s_dy_g -= 0.01
                    redraw = True
                elif event.key == pygame.K_z:
                    if self.x_m < self.X_M_MAX:
                        self.x_m += 0.01
                    redraw = True
                elif event.key == pygame.K_x:
                    if self.x_m > self.X_M_MIN:
                        self.x_m -= 0.01
                    redraw = True
                elif event.key == pygame.K_SPACE:
                    self.speed = 0.0
                    self.zoom_speed = 0.0
                    self.s_dx = 0.0
                    self.s_dy = 0.0
                    self.dx = 0.0
                    self.dy = 0.0
                    self.s_dx_g = 0.0
                    self.s_dy_g = 0.0
                    self.dx_g = 0.0
                    self.dy_g = 0.0
                    self.angle = 0.0
                    self.x_m = 1.880
                    self.zoom = self.MAX_ZOOM
                    redraw = True
            elif event.type == pygame.KEYUP:
                    self.speed = 0.0
                    self.zoom_speed = 0.0
                    self.s_dx = 0.0
                    self.s_dy = 0.0
                    self.s_dx_g = 0.0
                    self.s_dy_g = 0.0
                    redraw = True
        return redraw

    def updateScreen(self, img):
        self.angle += self.speed
        s_dx1, s_dy1 = rotate2D((self.s_dx,self.s_dy), -self.angle*DEG_RAD)
        s_dx1_g, s_dy1_g = rotate2D((self.s_dx_g,self.s_dy_g), -self.angle*DEG_RAD)
        self.dx += s_dx1*self.zoom
        self.dy += s_dy1*self.zoom
        self.dx_g += s_dx1_g
        self.dy_g += s_dy1_g
    
        if self.zoom > self.MIN_ZOOM and self.zoom < self.MAX_ZOOM:
            self.zoom += self.zoom_speed*self.zoom
        if self.zoom <= self.MIN_ZOOM:
            self.zoom_speed = 0.0
            self.zoom = self.MIN_ZOOM+self.MIN_ZOOM/10.0
        if self.zoom >= self.MAX_ZOOM:
            self.zoom_speed = 0.0
            self.zoom = self.MAX_ZOOM-self.MIN_ZOOM
            
        pygame.display.set_caption(f'offset_g {self.dx_g:.3f} {self.dy_g:.3f} Zoom {round(1.0/self.zoom,3)} angle {self.angle} deg size {self.zoom:.5f} x_m {self.x_m:.3f}')
        display.blit(img,(0,0))
        frame_tex = surf_to_texture(display)
        frame_tex.use(0)
        program['tex'] = 0
        program['resolution'] = (float(SCR_SIZE),float(SCR_SIZE))
        program['angle'] = self.angle*DEG_RAD
        program['offset'] = (self.dx,self.dy)
        #program['offset_g'] = (self.dx_g, self.dy_g)
        #program['x_m'] = self.x_m
        program['scale'] = self.zoom
        render_object.render(mode=moderngl.TRIANGLE_STRIP)
        pygame.display.flip()
        frame_tex.release()

def loadShader(name):
    f = open(name)
    return "".join(f.readlines())

if __name__ == "__main__":
    t = 0
    screen = ScreenData()
    pygame.key.set_repeat(50)
    
    img_name = "" 
    if len(sys.argv)>1:
        frag_shader = loadShader('shaders/'+sys.argv[1]+'.glsl')
        img_name = 'textures/'+sys.argv[1]+'.jpg'
    program = ctx.program(vertex_shader=vert_shader, fragment_shader=frag_shader)
    render_object = ctx.vertex_array(program, [(quad_buffer, '2f 2f', 'vert', 'texcoord')])
    
    img = pygame.image.load(img_name)
    while True:
        if (t == 0 or screen.readEvents()):
            screen.updateScreen(img)
        t += 1
        clock.tick(25)
    
