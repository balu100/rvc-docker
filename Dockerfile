FROM nvidia/cuda:12.1.0-runtime-ubuntu22.04

#Expose infer-web port 7865
EXPOSE 7865

# Set noninteractive mode to prevent prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confold" ffmpeg aria2 g++ git gcc python3 python3-dev python3-pip && apt clean

# python
RUN pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu121

#Clone
RUN git -C /opt clone https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI.git

#set workdir
WORKDIR /opt/Retrieval-based-Voice-Conversion-WebUI

#Download Weights
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/D40k.pth -d /opt/Retrieval-based-Voice-Conversion-WebUI/assets/pretrained_v2/ -o D40k.pth
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/G40k.pth -d /opt/Retrieval-based-Voice-Conversion-WebUI/assets/pretrained_v2/ -o G40k.pth
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/f0D40k.pth -d /opt/Retrieval-based-Voice-Conversion-WebUI/assets/pretrained_v2/ -o f0D40k.pth
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/f0G40k.pth -d /opt/Retrieval-based-Voice-Conversion-WebUI/assets/pretrained_v2/ -o f0G40k.pth
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/uvr5_weights/HP2-人声vocals+非人声instrumentals.pth -d /opt/Retrieval-based-Voice-Conversion-WebUI/assets/uvr5_weights/ -o HP2-人声vocals+非人声instrumentals.pth
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/uvr5_weights/HP5-主旋律人声vocals+其他instrumentals.pth -d /opt/Retrieval-based-Voice-Conversion-WebUI/assets/uvr5_weights/ -o HP5-主旋律人声vocals+其他instrumentals.pth
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/hubert_base.pt -d /opt/Retrieval-based-Voice-Conversion-WebUI/assets/hubert -o hubert_base.pt
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/rmvpe.pt -d /opt/Retrieval-based-Voice-Conversion-WebUI/assets/hubert -o rmvpe.pt
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/rmvpe.pt -d /opt/Retrieval-based-Voice-Conversion-WebUI/assets/rmvpe -o rmvpe.pt

# Install dependencies
RUN pip install -r /opt/Retrieval-based-Voice-Conversion-WebUI/requirements.txt
RUN pip install poetry

# Define Volumes
VOLUME [ "/opt/Retrieval-based-Voice-Conversion-WebUI/weights", "/opt/Retrieval-based-Voice-Conversion-WebUI/logs" ]

# Run
CMD [ "python3", "infer-web.py" ]