Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99CA1C6FA8E
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Mar 2023 16:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjCBQQY (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 2 Mar 2023 11:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjCBQQT (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 2 Mar 2023 11:16:19 -0500
X-Greylist: delayed 980 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Mar 2023 08:16:12 PST
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A798956511
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Mar 2023 08:16:12 -0800 (PST)
X-ASG-Debug-ID: 1677772788-15c433101a17b0e0001-qsCQDO
Received: from [192.168.177.53] (213.219.188.14.adsl.dyn.edpnet.net [213.219.188.14]) by relay-b02.edpnet.be with ESMTP id BWddJje4ay14I6v5 for <linux-bcachefs@vger.kernel.org>; Thu, 02 Mar 2023 16:59:48 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Apparent-Source-IP: 213.219.188.14
Message-ID: <66e27279-eeb3-dd1e-811e-377d05ad84a1@kabelmail.de>
Date:   Thu, 2 Mar 2023 16:59:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US, nl-BE
To:     linux-bcachefs@vger.kernel.org
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
Subject: would torture testing devices before format be useful?
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ASG-Orig-Subj: would torture testing devices before format be useful?
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Start-Time: 1677772788
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 6007
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.105482
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello everyone,

Today, I requested a lot of time for bug hunting from a developer,
whereas it actually was a hardware failure which made the bcachefs filesystem perform very poor.
Random IO and discard options are known to cause issues with (mainly cheap) SSDs,
but are frequently used for foreground / promote targets.
While those cheap SSDs won't cause data corruption, it's probably not a good idea to keep them 
alive,
I saw an rsync copy dropping back to 10MiB/s instead of 150.
The reason for it was hard to retrieve, and while it was not bcachefs related, it really seemed 
like the code made mistakes.

Would it be a good idea to include a "torture check" option while formatting?
it should write random bytes, read random bytes, check sg_unmap operation and verify the 
integrity of the operation.

As an illustration of what I am thinking of: see below.  It does NOT compile, nor will it 
exactly do what I'd like to test.
I made it as an illustation which would be an easy to read decoration (I hope)!
Do you people think this is an added value? or completely not a good idea?

Janpieter Sollie

diff --git a/libbcachefs.c b/libbcachefs.c
index 092a54a..8b96a39 100644
--- a/libbcachefs.c
+++ b/libbcachefs.c
@@ -186,6 +186,50 @@ struct bch_sb *bch2_format(struct bch_opt_strs     fs_opt_strs,
        if (bch2_sb_realloc(&sb, 0))
                die("insufficient memory");

+       /* some devices may need checking: */
+       for (i = devs; i < devs + nr_devs; i++) {
+               if(opt_defined(opts, torture) {
+                       int test_iterator;
+                       unsigned long position_iterator[2];
+                       void* random_buffer = malloc(fs_opts.block_size);
+                       void* read_buffer = malloc(fs_opts.block_size);
+                       void* zero_buffer = calloc(fs_opts.block_size, 1);
+                       const int nr_of_tests = 0x001ffff; //not sure whether this will be enough
+                       /* generate a block of random data */
+                       if (getrandom(buffer, fs_opts.block_size, 0) != fs_opts.block_size)
+                               die("internal torture test error");
+                       /* open the device as synchronous as possible */
+                       i->fd = open(i->path, O_RDWR, O_DIRECT | O_DSYNC);
+                       if(i->fd = -1)
+                               die("torture test error: opening device %s failed", i->path);
+
+                       /* start round zero: */
+                       position_iterator[0] = (unsigned long) (random() % fs_opts.size) / 
fs_opts.block_size;
+                       position_iterator[1] = (unsigned long) (random() % fs_opts.size) / 
fs_opts.block_size;
+                       lseek(i->fd, position_iterator[0] * fs_opts.block_size, SEEK_SET);
+                       write(i->fd, random_buffer, fs_opts.block_size);
+                       lseek(i->fd, position_iterator[1] * fs_opts.block_size, SEEK_SET);
+                       write(i->fd, zero_buffer, fs_opts.block_size); // this has to be 
adjusted to be a sg_unmap like operation
+
+                       for( test_iterator = 0; test_iterator < nr_of_tests; test_iterator++ ) {
+                               // verify previous round
+                               lseek(i->fd, position_iterator[0] * fs_opts.block_size, SEEK_SET);
+                               read(i->fd, read_buffer, fs_opts.block_size);
+                               if( memcmp(read_buffer, random_buffer, fs_opts.block_size) != 0) 
die ("random torture test failed at device %s", i->path);
+                               lseek(i->fd, position_iterator[0] * fs_opts.block_size, SEEK_SET);
+                               read(i->fd, zero_buffer, fs_opts.block_size);
+                               if( memcmp(read_buffer, zero_buffer, fs_opts.block_size) != 0) 
die ("zero torture test failed at device %s", i->path);
+                               /* write new round: */
+                               position_iterator[0] = (unsigned long) (random() % fs_opts.size) 
/ fs_opts.block_size;
+                               position_iterator[1] = (unsigned long) (random() % fs_opts.size) 
/ fs_opts.block_size;
+                               lseek(i->fd, position_iterator[0] * fs_opts.block_size, SEEK_SET);
+                               write(i->fd, random_buffer, fs_opts.block_size);
+                               lseek(i->fd, position_iterator[1] * fs_opts.block_size, SEEK_SET);
+                               write(i->fd, zero_buffer, fs_opts.block_size);  //again, needs 
to be adjusted to become discard / unmap operation
+                       }
+               }
+       }
+
        sb.sb->version          = le16_to_cpu(opts.version);
        sb.sb->version_min      = le16_to_cpu(opts.version);
        sb.sb->magic            = BCHFS_MAGIC;
