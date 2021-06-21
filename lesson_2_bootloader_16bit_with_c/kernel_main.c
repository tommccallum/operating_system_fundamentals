void main() {
    // point at our memory
    char* video_memory = (char*) 0xb8000;
    // place an X at the top of the screen
    *video_memory = 'X';
}