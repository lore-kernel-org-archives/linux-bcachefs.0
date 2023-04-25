Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9929EC77B71
	for <linux-bcachefs@archiver.kernel.org>; Tue, 25 Apr 2023 09:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbjDYJ0W (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 25 Apr 2023 05:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233169AbjDYJ0V (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 25 Apr 2023 05:26:21 -0400
X-Greylist: delayed 1011 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Apr 2023 02:26:19 PDT
Received: from relay-b01.edpnet.be (relay-b01.edpnet.be [212.71.1.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07B73A85
        for <linux-bcachefs@vger.kernel.org>; Tue, 25 Apr 2023 02:26:19 -0700 (PDT)
X-ASG-Debug-ID: 1682413763-15c4341ed66b0ea0001-qsCQDO
Received: from [192.168.177.53] (213.219.188.14.adsl.dyn.edpnet.net [213.219.188.14]) by relay-b01.edpnet.be with ESMTP id 3A0pWFYyUpGItTOP for <linux-bcachefs@vger.kernel.org>; Tue, 25 Apr 2023 11:09:23 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Apparent-Source-IP: 213.219.188.14
Message-ID: <09ee430c-9ef3-74cf-1738-3cbf96577af5@kabelmail.de>
Date:   Tue, 25 Apr 2023 11:08:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US, nl-BE
To:     linux-bcachefs@vger.kernel.org
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
Subject: [PATCH] add --data_types for bcachefs device add
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ASG-Orig-Subj: [PATCH] add --data_types for bcachefs device add
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Start-Time: 1682413763
X-Barracuda-URL: https://212.71.1.221:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 3328
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.107901
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi everyone,

bcachefs format allows to specify data types allowed on a specific device
(eg: to enforce caching on cheap SSDs while btree info is kept for SSDs with higher TBW),
but this currently is not available when adding a device with bcachefs format.

The patch below adds this functionality.  It is kept as minimal as possible,
but in the future maybe the OPTS from bcachefs format can be imported
instead of the specific opts of device add

Kind regards,

Janpieter Sollie

diff --git a/cmd_device.c b/cmd_device.c
index c59d370..1e8137b 100644
--- a/cmd_device.c
+++ b/cmd_device.c
@@ -41,6 +41,16 @@int device_usage(void)
        return 0;
}

+static u64 read_flag_list_or_die(char *opt, const char * const list[],
+                          const char *msg)
+{
+        u64 v = bch2_read_flag_list(opt, list);
+        if (v == (u64) -1)
+                die("Bad %s %s", msg, opt);
+
+        return v;
+}
+
static void device_add_usage(void)
{
        puts("bcachefs device add - add a device to an existing filesystem\n"
@@ -51,6 +61,7 @@static void device_add_usage(void)
             "  -B, --bucket=size           Bucket size\n"
             "  -D, --discard               Enable discards\n"
             "  -l, --label=label           Disk label\n"
+     "  -a, --data_allowed=types    allowed data on this device\n"
             "  -f, --force                 Use device even if it appears to already be 
formatted\n"
             "  -h, --help                  Display this help and exit\n"
             "\n"
@@ -64,6 +75,7 @@int cmd_device_add(int argc, char *argv[])
                { "bucket",             required_argument,      NULL, 'B' },
                { "discard",            no_argument,            NULL, 'D' },
                { "label",              required_argument,      NULL, 'l' },
+{ "data_allowed",       required_argument,      NULL, 'a' },
                { "force",              no_argument,            NULL, 'f' },
                { "help",               no_argument,            NULL, 'h' },
                { NULL }
@@ -90,6 +102,11 @@int cmd_device_add(int argc, char *argv[])
                case 'l':
                        dev_opts.label = strdup(optarg);
                        break;
+                case 'a':
+                        dev_opts.data_allowed =
+                                read_flag_list_or_die(optarg,
+                                        bch2_data_types, "data type");
+                        break;
                case 'f':
                        force = true;
                        break;
