#ifndef RESOURCE_H
#define RESOURCE_H

#include "util.h"
#include "../crt.h"

bool_t resource_exists(const char *filename);
void *resource_get(const char *filename);
size_t resource_size(const char *filename);

#endif
