Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E4AC433E0
	for <linux-bcachefs@archiver.kernel.org>; Wed,  3 Mar 2021 06:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45F7464E75
	for <linux-bcachefs@archiver.kernel.org>; Wed,  3 Mar 2021 06:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376418AbhCCGkM (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 3 Mar 2021 01:40:12 -0500
Received: from relay-b01.edpnet.be ([212.71.1.221]:48620 "EHLO
        relay-b01.edpnet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449235AbhCBQQ4 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 2 Mar 2021 11:16:56 -0500
X-ASG-Debug-ID: 1614700832-15c43405f66c9400001-qsCQDO
Received: from [192.168.177.53] (213.219.166.252.adsl.dyn.edpnet.net [213.219.166.252]) by relay-b01.edpnet.be with ESMTP id sUpQNrqediQJlMzw for <linux-bcachefs@vger.kernel.org>; Tue, 02 Mar 2021 17:00:32 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.252.adsl.dyn.edpnet.net[213.219.166.252]
X-Barracuda-Apparent-Source-IP: 213.219.166.252
To:     linux-bcachefs@vger.kernel.org
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
Subject: patch for upgrading to 5.11
Message-ID: <c3d2a014-f8ae-e0a5-9a9e-4b78f1e53f7b@kabelmail.de>
X-ASG-Orig-Subj: patch for upgrading to 5.11
Date:   Tue, 2 Mar 2021 17:00:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------F94A1DAD0DC29DF8DF13F8F9"
Content-Language: en-US
X-Barracuda-Connect: 213.219.166.252.adsl.dyn.edpnet.net[213.219.166.252]
X-Barracuda-Start-Time: 1614700832
X-Barracuda-URL: https://212.71.1.221:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 477
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.50
X-Barracuda-Spam-Status: No, SCORE=0.50 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=BSF_RULE7568M
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.88267
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
        0.50 BSF_RULE7568M          Custom Rule 7568M
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This is a multi-part message in MIME format.
--------------F94A1DAD0DC29DF8DF13F8F9
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

This patch is a "hack", not a proper solution:

- It contains some things I'm not proud about (eg passing NULL to a function call)

- It contians things I'm not sure of (eg: does fopen need a exclusive lock n the device? or is
read/write sufficient?

Still, it allows me to patch to 5.11 kernel, and so far, everything is OK


Thank you Kent Overstreet for developing this FS!


Kind regards,


Janpieter Sollie


--------------F94A1DAD0DC29DF8DF13F8F9
Content-Type: text/x-patch; charset=UTF-8;
 name="move_to_5.11.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="move_to_5.11.patch"

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 2b6a300edf1d..1fa87def871e 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1303,13 +1303,16 @@ static int bch2_sync_fs(struct super_block *sb, int wait)
 	return bch2_journal_flush(&c->journal);
 }
 
-static struct bch_fs *bch2_path_to_fs(const char *dev)
+static struct bch_fs *bch2_path_to_fs(const char *devpath)
 {
 	struct bch_fs *c;
-	struct block_device *bdev = lookup_bdev(dev);
+        struct block_device *bdev;
+        dev_t dev;
+	int err = lookup_bdev(devpath, &dev);
+        bdev = blkdev_get_by_dev(dev, FMODE_READ | FMODE_WRITE, NULL);
 
-	if (IS_ERR(bdev))
-		return ERR_CAST(bdev);
+	if (err)
+		return ERR_PTR(-ENOENT);
 
 	c = bch2_bdev_to_fs(bdev);
 	bdput(bdev);
diff --git a/fs/bcachefs/str_hash.h b/fs/bcachefs/str_hash.h
index 9f0bd4405199..b07294df6a2d 100644
--- a/fs/bcachefs/str_hash.h
+++ b/fs/bcachefs/str_hash.h
@@ -12,7 +12,8 @@
 
 #include <linux/crc32c.h>
 #include <crypto/hash.h>
-#include <crypto/sha.h>
+#include <crypto/sha1.h>
+#include <crypto/sha2.h>
 
 static inline enum bch_str_hash_type
 bch2_str_hash_opt_to_type(struct bch_fs *c, enum bch_str_hash_opts opt)
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index eee7d6c011b6..663ed5e15c51 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -541,9 +541,8 @@ void __bch2_fs_stop(struct bch_fs *c)
 	for_each_member_device(ca, c, i)
 		if (ca->kobj.state_in_sysfs &&
 		    ca->disk_sb.bdev)
-			sysfs_remove_link(&part_to_dev(ca->disk_sb.bdev->bd_part)->kobj,
+			sysfs_remove_link(&(ca->disk_sb.bdev->bd_device.kobj),
 					  "bcachefs");
-
 	if (c->kobj.state_in_sysfs)
 		kobject_del(&c->kobj);
 
@@ -1005,7 +1004,7 @@ static void bch2_dev_free(struct bch_dev *ca)
 
 	if (ca->kobj.state_in_sysfs &&
 	    ca->disk_sb.bdev)
-		sysfs_remove_link(&part_to_dev(ca->disk_sb.bdev->bd_part)->kobj,
+		sysfs_remove_link(&(ca->disk_sb.bdev->bd_device.kobj),
 				  "bcachefs");
 
 	if (ca->kobj.state_in_sysfs)
@@ -1043,7 +1042,7 @@ static void __bch2_dev_offline(struct bch_fs *c, struct bch_dev *ca)
 
 	if (ca->kobj.state_in_sysfs) {
 		struct kobject *block =
-			&part_to_dev(ca->disk_sb.bdev->bd_part)->kobj;
+			&(ca->disk_sb.bdev->bd_device.kobj);
 
 		sysfs_remove_link(block, "bcachefs");
 		sysfs_remove_link(&ca->kobj, "block");
@@ -1083,7 +1082,7 @@ static int bch2_dev_sysfs_online(struct bch_fs *c, struct bch_dev *ca)
 
 	if (ca->disk_sb.bdev) {
 		struct kobject *block =
-			&part_to_dev(ca->disk_sb.bdev->bd_part)->kobj;
+			&(ca->disk_sb.bdev->bd_device.kobj);
 
 		ret = sysfs_create_link(block, &ca->kobj, "bcachefs");
 		if (ret)
@@ -1817,10 +1816,12 @@ int bch2_dev_resize(struct bch_fs *c, struct bch_dev *ca, u64 nbuckets)
 /* return with ref on ca->ref: */
 struct bch_dev *bch2_dev_lookup(struct bch_fs *c, const char *path)
 {
-	struct block_device *bdev = lookup_bdev(path);
+	struct block_device *bdev;
+	dev_t dev;
 	struct bch_dev *ca;
 	unsigned i;
-
+	int err = lookup_bdev(path, &dev);
+	bdev = blkdev_get_by_dev(dev, FMODE_READ | FMODE_WRITE, NULL);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);
 

--------------F94A1DAD0DC29DF8DF13F8F9--
