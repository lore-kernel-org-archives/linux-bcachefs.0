Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B2DEE57CA
	for <linux-bcachefs@archiver.kernel.org>; Fri,  8 Sep 2023 07:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjIHH3H (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 8 Sep 2023 03:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjIHH3G (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 8 Sep 2023 03:29:06 -0400
Received: from orion.157878.xyz (orion.157878.xyz [115.70.13.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FBC1BD2
        for <linux-bcachefs@vger.kernel.org>; Fri,  8 Sep 2023 00:29:02 -0700 (PDT)
From:   Colin Gillespie <colin@cgillespie.xyz>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cgillespie.xyz;
        s=2023; t=1694158140;
        bh=r+KlkbNFfrXcVXvCkvBDH/IIqeZXWzKazOZruCa/rz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=soa55zWpAb5GGtBRtw/EQidEB+iSDx0P54l3AvxLCA9qyXz3aOyeQqXUW5StvPqqS
         PT/u9uaMIqSX9J5l0oS3O9ym77EoXsdDkulSxm7aC4UlrK7crJysF9K/I/PVBDjZ++
         gZm/WpETPfX3iUGHGWThyw4Xe4qGxCJLADFi6TNAv5/uQRrgwCzSuw5LTR/Z8e5oM4
         mH4qQo2XQNGvQxKF7ZSq4cCaLzSQMYS7hGLBOLeVnb/mCyq+v2bLtT2Pw+uIq0aS9D
         Ceu+h9WYYYPRQ8WPift9lUs0MijiH1tGqXTm73XsypA/WzNQwFKVzJRMppDwDjiPVg
         Q5X12N5T7EuOw==
To:     linux-bcachefs@vger.kernel.org
Cc:     Colin Gillespie <colin@cgillespie.xyz>
Subject: [PATCH 1/2] cmd_set_passphrase: revoke the invalidated key
Date:   Fri,  8 Sep 2023 17:27:51 +1000
Message-ID: <20230908072751.25406-3-colin@cgillespie.xyz>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230908072751.25406-2-colin@cgillespie.xyz>
References: <20230908072751.25406-2-colin@cgillespie.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

After setting a new passphrase, the previous key is left untouched. This
revokes the old key, preventing future actions from using it in error.

Signed-off-by: Colin Gillespie <colin@cgillespie.xyz>
---
 cmd_key.c              |  1 +
 libbcachefs/checksum.c | 18 ++++++++++++++++++
 libbcachefs/checksum.h |  1 +
 3 files changed, 20 insertions(+)

diff --git a/cmd_key.c b/cmd_key.c
index e8c3eea..d3e5d7b 100644
--- a/cmd_key.c
+++ b/cmd_key.c
@@ -111,6 +111,7 @@ int cmd_set_passphrase(int argc, char *argv[])
 		die("error encrypting key");
 	crypt->key = new_key;
 
+	bch2_revoke_key(c->disk_sb.sb);
 	bch2_write_super(c);
 	bch2_fs_stop(c);
 	return 0;
diff --git a/libbcachefs/checksum.c b/libbcachefs/checksum.c
index 3693902..4c87c59 100644
--- a/libbcachefs/checksum.c
+++ b/libbcachefs/checksum.c
@@ -558,6 +558,24 @@ int bch2_request_key(struct bch_sb *sb, struct bch_key *key)
 	return ret;
 }
 
+int bch2_revoke_key(struct bch_sb *sb)
+{
+	key_serial_t key_id;
+	struct printbuf key_description = PRINTBUF;
+
+	prt_printf(&key_description, "bcachefs:");
+	pr_uuid(&key_description, sb->user_uuid.b);
+
+	key_id = request_key("user", key_description.buf, NULL, KEY_SPEC_USER_KEYRING);
+	printbuf_exit(&key_description);
+	if (key_id < 0)
+		return errno;
+
+	keyctl_revoke(key_id);
+
+	return 0;
+}
+
 int bch2_decrypt_sb_key(struct bch_fs *c,
 			struct bch_sb_field_crypt *crypt,
 			struct bch_key *key)
diff --git a/libbcachefs/checksum.h b/libbcachefs/checksum.h
index c7b1a8f..9a4898d 100644
--- a/libbcachefs/checksum.h
+++ b/libbcachefs/checksum.h
@@ -48,6 +48,7 @@ struct bch_csum bch2_checksum(struct bch_fs *, unsigned, struct nonce,
 
 int bch2_chacha_encrypt_key(struct bch_key *, struct nonce, void *, size_t);
 int bch2_request_key(struct bch_sb *, struct bch_key *);
+int bch2_revoke_key(struct bch_sb *);
 
 int bch2_encrypt(struct bch_fs *, unsigned, struct nonce,
 		 void *data, size_t);
-- 
2.42.0

