#include "my_application.h"

int main(int argc, char** argv) {
  const char* snap_name = g_getenv("SNAP_NAME");
  if (g_strcmp0(snap_name, "code") == 0 &&
      g_getenv("WAYLAND_DISPLAY") != nullptr &&
      g_getenv("DISPLAY") != nullptr && g_getenv("GDK_BACKEND") == nullptr) {
    g_setenv("GDK_BACKEND", "x11", FALSE);
  }

  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
