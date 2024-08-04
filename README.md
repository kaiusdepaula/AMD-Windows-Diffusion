# AMD-Windows-Diffusion
Running Stable Diffusion on an AMD GPU, especially on a Windows machine, can be quite challenging. After successfully setting up Stable Diffusion on my Manjaro Linux system using ROCm, I decided to create a solution that could work universally on any machine with Docker support. This project is an attempt to simplify the process of running Stable Diffusion on an AMD GPU, even on Windows, using Docker.

**Important:** this is a unfinished project. I tried my best to make ROCm work with Windows, but my main issue was with WSL kernel. It's not supported. You may try to do it using a VM, but if you really insist, there maybe a way of do it using Docker, I guess there is hope if you can downgrade the version of WSL Kernel.

# The beggining
A year ago, Stable Diffusion was quite famous as the interest in text-to-image technologies rose (let's thank OpenAi for that). I was really looking forward to experiment on it as well, as I still have at the time a `Ryzen 6700XT` with 12GB of VRAM to spare. I knew I should try it out locally on my PC.

With this, comes the first realization: AMD is great, but it sucks. 

Running any `Python` library that requires the use of a `cuda core` is essentially asking for AMD to develop a workaround for their users to run "nvidia software" using their hardware. At least it seems that way, because it's quite literally a dependency hell.

After weeks trying to make the ROCm (which is the specific workaround for making the gpu run code) run on my OS (manjaro), I did it. It requires patience, but it's possible to do on a **Linux** machine.

A year passed, some dependencies broke and this is how I learned to separate system to project files. (Not proud of that...)

A random weekend I finished a Docker course on `DataCamp` and had the idea to create a `Image` of a working Stable Diffusion model in which I could safeguard for a long time. This is how this project came to fruition. 

# The challenge

The plan was quite simple and I planned to have it done by the end of the first day (I was very off...). A week has passed and I realized that some things may not be worth the challenge.

Still, if you really wish to try you luck and make Rocm work on Windows using Docker, this is what I've learned after a week dedicated to a project that was planned for a single day.

1. Check the supported Linux kernel that you are using for running ROCm. A simple `uname -a` may tell you if it's worth trying to fix some issue. 
2. If you are running on Windows, check you WSL! I've came to a conclusion on this project just because changing the WSL is a viable option for a GH repo. I guess there are ways, but it's not worth it.
3. If you have a unsuported AMD GPU (such as mine), try running  `export HSA_OVERRIDE_GFX_VERSION=10.3.0`. (On my personal machine this made running rocm possible.)
4. **IMPORTANT!** Follow a layer strategy. First, update all, install rocm, check if gpu is recognisable `$ rocminfo` (run on terminal.).
5. Check if the correct version of pytorch is being used.

I'll still provide my Dockerfile with what I've developd  in the past few days. You can try to build it using `docker build -t SDW` and (if it's not broken) `docker run -e HSA_OVERRIDE_GFX_VERSION=10.3.0 -it --device /dev/kfd --device /dev/dri --security-opt seccomp=unconfined --privileged SDW`.

# Conclusion
While the project did not achieve its intended goal, it provided a deeper understanding of the challenges associated with running GPU-accelerated applications on heterogeneous platforms. Future work may involve revisiting the project as the technology stack matures, especially with anticipated improvements in WSL, Docker, and ROCm support for Windows.

# Acknowledgments
- Thanks to the open-source community for providing the tools and resources that made this exploration possible.
- Special thanks to the developers of ROCm, Docker, and WSL for their ongoing efforts in advancing technology.

# License
This project is licensed under the MIT License - see the LICENSE file for details.