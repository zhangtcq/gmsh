#include <GLES/gl.h>
#include <GLES/glext.h>

#include "drawString.h"

drawString::drawString(std::string text, int size, float color[4])
{
	_size = size;
	if(color == NULL)
		this->setColor(0.0f, 0.0f, 0.0f, 1.0f);
	else
		this->setColor(color);
	this->setText(text);
}

void drawString::setText(std::string text)
{
	this->_text = text;
	getBitmapFromString(this->_text.c_str(), _size, &this->_map, &this->_height, &this->_width, &this->_realWidth);
}

void drawString::setColor(float color[4])
{
	_color[0] = color[0];
	_color[1] = color[1];
	_color[2] = color[2];
	_color[3] = color[3];
}

void drawString::setColor(float r, float g, float b, float a)
{
	_color[0] = r;
	_color[1] = g;
	_color[2] = b;
	_color[3] = a;
}
void drawString::draw(float x, float y, float z, float w, float h, bool center)
{
	GLuint textureId;
	glGenTextures(1, &textureId);
	glBindTexture(GL_TEXTURE_2D, textureId);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, _width, _height, 0, GL_ALPHA, GL_UNSIGNED_BYTE, _map);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glColor4f(_color[0], _color[1], _color[2], _color[3]);
	if(center)
		x-=(float)_realWidth/w/2;
	GLfloat vertex[] = {
		 x, y, z, // bottom left
		 x, y+(float)_height/h, z, // top left
		 x+(float)_width/w, y, z, // bottom right
		 x+(float)_width/w, y+(float)_height/h, z, // top right
	};
	GLfloat texture[] = {
		0.0f, 1.0f, // top left
		0.0f, 0.0f, // bottom left
		1.0f, 1.0f, // top right
		1.0f, 0.0f, // bottom right
	};
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_LIGHTING);
	glVertexPointer(3, GL_FLOAT, 0, vertex);
	glTexCoordPointer(2, GL_FLOAT, 0, texture);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	glDisable(GL_TEXTURE_2D);
	glDisable(GL_BLEND);
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDeleteTextures(1, &textureId);
}