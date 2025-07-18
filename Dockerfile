FROM debian:bookworm

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    curl \
    pkg-config \
    libicu-dev \
    libmecab-dev \
    mecab \
    mecab-ipadic-utf8 \
    libsvm-dev \
    libsvm-tools \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create work directory
WORKDIR /opt

# Clone resembla repository
RUN git clone https://github.com/tuem/resembla.git /opt/resembla

# Copy ICU namespace fix patch
COPY patches/icu-namespace-fix.patch /tmp/

# Apply ICU namespace fix and add missing headers
RUN cd /opt/resembla/src && \
    sed -i '/#include "symbol_normalizer.hpp"/a using namespace icu;' string_normalizer.hpp && \
    sed -i '/#include "symbol_normalizer.hpp"/a using namespace icu;' string_normalizer.cpp && \
    sed -i '/#include "string_util.hpp"/a using namespace icu;' symbol_normalizer.hpp && \
    sed -i '/#include <unicode\/normlzr.h>/a using namespace icu;' symbol_normalizer.cpp && \
    sed -i '/#include <fstream>/a #include <unicode/unistr.h>\nusing namespace icu;' string_util.hpp && \
    sed -i '/#include <unicode\/unistr.h>/a using namespace icu;' string_util.cpp && \
    sed -i '1i#include <cstddef>' measure/romaji_weight.hpp && \
    sed -i '1i#include <cstddef>' measure/romaji_weight.cpp

# Build libresembla
RUN cd /opt/resembla/src && \
    make clean && \
    make && \
    make install && \
    ldconfig

# Build executables
RUN cd /opt/resembla/src/executable && \
    make clean && \
    make && \
    make install

# Install UniDic (optional dictionary)
RUN cd /opt/resembla/misc/mecab_dic/unidic && \
    bash ./install-unidic.sh || true

# Install mecab-unidic-neologd (optional dictionary)
RUN cd /opt/resembla/misc/mecab_dic/mecab-unidic-neologd && \
    bash ./install-mecab-unidic-neologd.sh -y || true

# Copy and run example data setup script
COPY scripts/setup-example-data.sh /tmp/
RUN chmod +x /tmp/setup-example-data.sh && /tmp/setup-example-data.sh

# Create entrypoint script
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set working directory for runtime
WORKDIR /data

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["--help"]