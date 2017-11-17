package main

import (
	"fmt"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Println("running script...")
	cwd, err := os.Getwd()
	if err != nil {
		fmt.Printf("get current path error: %v\n", err)
		return
	}
	scriptPath := filepath.Join(cwd, "generate.sh")
	_, err = exec.Command("/bin/sh", scriptPath).Output()
	if err != nil {
		fmt.Printf("Convert file error: %s", err)
	}
}

func main() {
	http.HandleFunc("/new_issue", handler)
	http.ListenAndServe(":19019", nil)
}
