#include <stdio.h>

int main() {
    printf("start\n");

    if (1) {
        int x = 5;
        if (x > 0) {
            int y = x * 2;
            if (y > 5) {
                int z = y - 3;
                if (z < 10) {
                    for (int i = 0; i < 2; i++) {
                        if (i == 0) {
                            while (z > 0) {
                                z--;
                                if (z % 2 == 0) {
                                    printf("even: %d\n", z);
                                    if (z == 2) {
                                        printf("very close now\n");
                                        if (z > 1) {
                                            printf("deeper still\n");
                                            if (z == 2) {
                                                printf("yes yes\n");
                                                if (z == 2) {
                                                    printf("context context\n");
                                                    if (z == 2) {
                                                        printf(
                                                            "tree sitter "
                                                            "maxxx\n");
                                                        if (z == 2) {
                                                            printf(
                                                                "hang in "
                                                                "there!\n");
                                                            if (z == 2) {
                                                                printf(
                                                                    "almost at "
                                                                    "max\n");
                                                                if (z == 2) {
                                                                    printf(
                                                                        "last "
                                                                        "level "
                                                                        "maybe?"
                                                                        "\n");
                                                                    if (z ==
                                                                        2) {
                                                                        printf(
                                                                            "no"
                                                                            "pe"
                                                                            "! "
                                                                            "on"
                                                                            "e "
                                                                            "mo"
                                                                            "re"
                                                                            "!"
                                                                            "\n");
                                                                        if (z ==
                                                                            2) {
                                                                            printf(
                                                                                "we made it!\n");
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    printf("end\n");
    return 0;
}
