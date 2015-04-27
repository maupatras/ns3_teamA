#include <iostream>
#include <gtkmm.h>
#include <gtk/gtk.h>
#include <unistd.h>
#include <sstream>
#include <string>

using namespace std;

void on_button_click();
void on_button_exit();

void frame_callback(GtkWindow *window, 
      GdkEvent *event, gpointer data)
{
   int x, y;
   char buf[10];
   x = event->configure.x;
   y = event->configure.y;
   sprintf(buf, "%d, %d", x, y);
   gtk_window_set_title(window, buf);
}

int main(int argc, char* argv[]) {

	GtkWidget *window;
	GtkWidget *fixed;
	GtkWidget *button1, *button2;
	GtkWidget *label_head, *label_text1, *label_text2, *label_text3;

	gtk_init(&argc, &argv);


	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	gtk_window_set_title(GTK_WINDOW(window), "NS-3 Installation Guide");
	gtk_window_set_default_size(GTK_WINDOW(window), 500, 200);
	gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);

	fixed = gtk_fixed_new();
	gtk_container_add(GTK_CONTAINER(window), fixed);

	label_head = gtk_label_new(NULL);
	gtk_label_set_markup(GTK_LABEL(label_head), "<b>NS-3 Installation Guide</b>");
	gtk_fixed_put(GTK_FIXED(fixed), label_head, 10, 10);
	gtk_widget_set_size_request(label_head, 200, 35);

	label_text1 = gtk_label_new(NULL);
	gtk_label_set_markup(GTK_LABEL(label_text1), "Press Start Button and a terminal window will appear");
	gtk_fixed_put(GTK_FIXED(fixed), label_text1, 0, 50);
	gtk_widget_set_size_request(label_text1, 410, 35);

	label_text2 = gtk_label_new(NULL);
	gtk_label_set_markup(GTK_LABEL(label_text2), "in order to select the version of NS-3 that you want to install.");
	gtk_fixed_put(GTK_FIXED(fixed), label_text2, 6, 70);
	gtk_widget_set_size_request(label_text2, 450, 35);

	label_text3 = gtk_label_new(NULL);
	gtk_label_set_markup(GTK_LABEL(label_text3), "After installation press Close and Exit button!");
	gtk_fixed_put(GTK_FIXED(fixed), label_text3, 7, 90);
	gtk_widget_set_size_request(label_text3, 350, 50);

	button1 = gtk_button_new_with_label("Start Installation now");
	gtk_fixed_put(GTK_FIXED(fixed), button1, 30, 140);
	gtk_widget_set_size_request(button1, 200, 35);
	g_signal_connect(G_OBJECT(button1), "clicked", 
	  G_CALLBACK(on_button_click), NULL);

	button2 = gtk_button_new_with_label("Close and Exit");
	gtk_fixed_put(GTK_FIXED(fixed), button2, 270, 140);
	gtk_widget_set_size_request(button2, 200, 35);
	g_signal_connect(G_OBJECT(button2), "clicked", 
	  G_CALLBACK(on_button_exit), NULL);

	gtk_widget_show_all(window);

	gtk_main();

	return 0;

}

void on_button_click() {

	char *path = NULL;
	path = getcwd(NULL, 0); // or _getcwd
	if ( path != NULL)
	printf("%s\n", path);

	std::ostringstream oss;
	oss << "xterm -e sh -c 'cd; cd " << path << "; chmod a+x configure.sh; ./configure.sh; exec bash'";
	std::string cmd = oss.str();
	system (cmd.c_str());

}

void on_button_exit() {

	gtk_main_quit();
	system ("exit");

}
