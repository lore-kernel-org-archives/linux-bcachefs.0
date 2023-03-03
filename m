Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E8F5C64EC4
	for <linux-bcachefs@archiver.kernel.org>; Fri,  3 Mar 2023 12:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjCCMWR (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 3 Mar 2023 07:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCCMWQ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 3 Mar 2023 07:22:16 -0500
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5CC5B5D4
        for <linux-bcachefs@vger.kernel.org>; Fri,  3 Mar 2023 04:22:14 -0800 (PST)
X-ASG-Debug-ID: 1677846131-15c433101a25a710001-qsCQDO
Received: from [192.168.177.53] (213.219.188.14.adsl.dyn.edpnet.net [213.219.188.14]) by relay-b02.edpnet.be with ESMTP id CJBgQdGYmCzWbOMz for <linux-bcachefs@vger.kernel.org>; Fri, 03 Mar 2023 13:22:11 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Apparent-Source-IP: 213.219.188.14
Message-ID: <fb79ef69-7b0b-c790-a212-ca1cf76da8cd@kabelmail.de>
Date:   Fri, 3 Mar 2023 13:21:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US, nl-BE
To:     linux-bcachefs@vger.kernel.org
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
Subject: [PATCH v0] implement torture test when formatting device
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ASG-Orig-Subj: [PATCH v0] implement torture test when formatting device
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Start-Time: 1677846131
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 8530
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.105518
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi everyone,

following my question yesterday:
hereby what I'd suggest as a torture test when formatting the device,
it would be implemented as a "torture" option, and not set by default.
Whereas this code is still not failproof (which will be for v1), and error handling should be 
returned instead of dying,
is it worth it to keep writing in libbcachefs.c?
Or should I go completely rust-way instead?

Janpieter Sollie

diff --git a/cmd_format.c b/cmd_format.c
index 26a1cd9..17eff3d 100644
--- a/cmd_format.c
+++ b/cmd_format.c
@@ -40,6 +40,7 @@ x(0,  superblock_size,        required_argument)      \
x(0,   bucket_size,            required_argument)      \
x('l', label,                  required_argument)      \
x(0,   discard,                no_argument)            \
+x(0,   torture,                no_argument)            \
x(0,   data_allowed,           required_argument)      \
x(0,   durability,             required_argument)      \
x(0,   version,                required_argument)      \
@@ -180,6 +181,9 @@ int cmd_format(int argc, char *argv[])
                case O_discard:
                        dev_opts.discard = true;
                        break;
+               case O_torture:
+                       opts.torture = true;
+                       break;
                case O_data_allowed:
                        dev_opts.data_allowed =
                                read_flag_list_or_die(optarg,
diff --git a/libbcachefs.c b/libbcachefs.c
index 092a54a..8b39654 100644
--- a/libbcachefs.c
+++ b/libbcachefs.c
@@ -8,6 +8,8 @@
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
+#include <sys/random.h>
+#include <sys/ioctl.h>
#include <sys/sysmacros.h>
#include <sys/types.h>
#include <time.h>
@@ -27,6 +29,11 @@
#include "libbcachefs/super-io.h"
#include "tools-util.h"

+
+#ifndef BLKDISCARD
+# define BLKDISCARD    _IO(0x12,119)
+#endif
+
#define NSEC_PER_SEC   1000000000L

static void init_layout(struct bch_sb_layout *l,
@@ -142,6 +149,72 @@ static unsigned parse_target(struct bch_sb_handle *sb,
        return 0;
}

+static int torture_target(struct dev_opts* i, const struct bch_opts fs_opts)
+{
+       const uint32_t nr_of_tests = 0x001ffff; //not sure whether this will be enough
+       uint32_t test_iterator;
+       uint64_t position_iterator[2];
+       uint64_t range[2];
+       void* random_buffer = malloc(fs_opts.block_size);
+       void* read_buffer = malloc(fs_opts.block_size);
+       void* zero_buffer = calloc(fs_opts.block_size, 1);
+
+       /* generate a block of random data */
+       if (getrandom(random_buffer, fs_opts.block_size, 0) != fs_opts.block_size)
+               die("internal torture test error");
+
+       /* open the device as synchronous as possible */
+       i->fd = open(i->path, O_RDWR, O_DIRECT | O_SYNC);
+       if(i->fd == -1)
+               die("torture test error: opening device %s failed", i->path);
+
+       /* start round zero: */
+       position_iterator[0] = (uint64_t) (random() % i->size) / fs_opts.block_size;
+       position_iterator[1] = (uint64_t) (random() % i->size) / fs_opts.block_size;
+       range[0] = position_iterator[1] * fs_opts.block_size;
+       range[1] = fs_opts.block_size;
+
+       lseek(i->fd, position_iterator[0] * fs_opts.block_size, SEEK_SET);
+       if (write(i->fd, random_buffer, fs_opts.block_size) == -1)
+               die("torture testing write operation failed %s", i->path);
+       if (i->discard && ioctl(i->fd, BLKDISCARD, &range))
+               die("torture testing discard operation failed %s", i->path);
+
+       for( test_iterator = 0; test_iterator < nr_of_tests; test_iterator++ )
+       {
+                       /* verify previous round */
+                       lseek(i->fd, position_iterator[0] * fs_opts.block_size, SEEK_SET);
+                       if (read(i->fd, read_buffer, fs_opts.block_size) == -1)
+                               die ("random torture test read error at device %s", i->path);
+                       if ( memcmp(read_buffer, random_buffer, fs_opts.block_size) != 0)
+                               die ("random torture test integrity check failed at device %s", 
i->path);
+                       if (i->discard)
+                       {
+                               lseek(i->fd, position_iterator[0] * fs_opts.block_size, SEEK_SET);
+                               if ( read(i->fd, read_buffer, fs_opts.block_size) == -1 ||
+                                       memcmp(read_buffer, zero_buffer, fs_opts.block_size) != 0)
+                                       die ("random torture test discarded read failed at 
device %s", i->path);
+                       }
+
+                       /* write new round: */
+                       position_iterator[0] = (uint64_t) (random() % i->size) / 
fs_opts.block_size;
+                       position_iterator[1] = (uint64_t) (random() % i->size) / 
fs_opts.block_size;
+                       range[0] = position_iterator[1] * fs_opts.block_size;
+
+                       lseek(i->fd, position_iterator[0] * fs_opts.block_size, SEEK_SET);
+                       if (write(i->fd, random_buffer, fs_opts.block_size) == -1)
+                               die("torture testing write operation failed %s", i->path);
+                       if (i->discard && ioctl(i->fd, BLKDISCARD, &range))
+                               die("torture testing discard operation failed %s", i->path);
+       }
+
+       close(i->fd);
+       free(random_buffer);
+       free(read_buffer);
+       free(zero_buffer);
+       return 0;
+}
+
struct bch_sb *bch2_format(struct bch_opt_strs fs_opt_strs,
                           struct bch_opts      fs_opts,
                           struct format_opts   opts,
@@ -186,6 +259,10 @@ struct bch_sb *bch2_format(struct bch_opt_strs     fs_opt_strs,
        if (bch2_sb_realloc(&sb, 0))
                die("insufficient memory");

+       /* some devices may need checking: */
+       if(opts.torture)
+               for (i = devs; i < devs + nr_devs; i++) torture_target(i, fs_opts);
+
        sb.sb->version          = le16_to_cpu(opts.version);
        sb.sb->version_min      = le16_to_cpu(opts.version);
        sb.sb->magic            = BCHFS_MAGIC;
diff --git a/libbcachefs.h b/libbcachefs.h
index 4bb51bd..bce9894 100644
--- a/libbcachefs.h
+++ b/libbcachefs.h
@@ -37,6 +37,7 @@ struct format_opts {
        unsigned        superblock_size;
        bool            encrypted;
        char            *passphrase;
+       bool            torture;
};

static inline struct format_opts format_opts_default()
@@ -48,6 +49,7 @@ static inline struct format_opts format_opts_default()
        return (struct format_opts) {
                .version                = version,
                .superblock_size        = SUPERBLOCK_SIZE_DEFAULT,
+               .torture                = false,
        };
}
