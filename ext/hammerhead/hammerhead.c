#include "hammerhead.h"

VALUE rb_mHammerhead;

void
Init_hammerhead(void)
{
  rb_mHammerhead = rb_define_module("Hammerhead");
}
