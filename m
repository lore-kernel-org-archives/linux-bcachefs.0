Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D32CC001B0
	for <linux-bcachefs@archiver.kernel.org>; Sun, 13 Aug 2023 17:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjHMRih (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 13:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjHMRih (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 13:38:37 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCB11707
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 10:38:39 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-3179ed1dfbbso3268290f8f.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 10:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691948317; x=1692553117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9w29Os0whbP+QGRAWOByOJrpYHNRbRm4EUfBgz2p0L4=;
        b=lfG4a8fhsQu5RxXVjzarwLxU2QvP+cqp3Rv75NMsORCuN/OVhV31QG64p4fCtA5A4X
         e8FULAirHPGjVCjPoR03TLGzKEZRM9bf44N5eJlrGG4NEEELL2BgRjF2AUSLGsYJ8SgU
         jNOixXVKvTelAfZdXPjdG/kcdS42ICDlSX24Fjge0oYNZG1iqdfnvrcUIWYt8ddJZPxi
         bORtE5e95U2zUQfp1Xc6N+0Q3CSUbLWEiSkb+rikD5NmqIKK7+bjqY5Yl4MfQgIZ+HYH
         IBiwJ9K8CGR5o9l/WTwq6XSKz+snrlsk/EuBTyfGYslV/3XEyPO8dLhhg0MHF7VnIwbJ
         VMlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691948317; x=1692553117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9w29Os0whbP+QGRAWOByOJrpYHNRbRm4EUfBgz2p0L4=;
        b=kIgA/nIxXlI+kn3CG6zIWOVVl4H22hAs9j2easotiSPdx8VZsbwa7SIZTy2YFKl2D7
         3+wWMWIQyRJM9w0eiUMNz7qszZRuYi+v/1mENOd/Y/F1fOD/tezg8klqT8hmaPnF1x+Y
         Ggy6U9SXx3V+Cx1HDS9zb0bNryiJ2Ns3iM0w2p8q4h2UimcONQyqpO25HIs4NSd3FLEV
         UqCO44kSFsGa6HaBLuJ53cYicia5dfCE23O4wasnEEE4KRCSjecQwiH/dbHHB/gnqvA8
         G8SAlLYyJMIPOYXQ3y0x88c0+TQegM2Mh39L2UDswKmspA1YXK7ToMHP3DOm/MQbc0q/
         BXXQ==
X-Gm-Message-State: AOJu0YxlKWB+HQgHIQI+M7OlgzRxwXQV4MFA9WUzzs5Oc+TUS9lB4S/3
        GU65dcBlvNRv7e83WNiMBrW4Eog7snPtpkfjGeM=
X-Google-Smtp-Source: AGHT+IGORlhHJqcew4Hbc/kHzJbeutNbfFd7iiHiUCX9khmHxPNKUOsD6VFZfwxMTcAwGarVq2HMKg==
X-Received: by 2002:adf:fb44:0:b0:319:6f0e:fc0e with SMTP id c4-20020adffb44000000b003196f0efc0emr2854930wrs.30.1691948317534;
        Sun, 13 Aug 2023 10:38:37 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id s6-20020a5d5106000000b003141a3c4353sm11962115wrt.30.2023.08.13.10.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Aug 2023 10:38:37 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>
Subject: [v3 1/3] bcachefs: Split out dirent alloc and name initialization
Date:   Sun, 13 Aug 2023 18:38:25 +0100
Message-ID: <20230813173835.195840-2-joshua@froggi.es>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813173835.195840-1-joshua@froggi.es>
References: <20230813173835.195840-1-joshua@froggi.es>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Splits out the code that allocates the dirent and initializes the name
to make things easier to implement casefolding in a future commit.

Signed-off-by: Joshua Ashton <joshua@froggi.es>
---
 fs/bcachefs/dirent.c | 46 ++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index a7559ab03802..85769d5c6b82 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -169,15 +169,13 @@ void bch2_dirent_to_text(struct printbuf *out, struct bch_fs *c,
 	       bch2_d_type_str(d.v->d_type));
 }
 
-static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
-				subvol_inum dir, u8 type,
-				const struct qstr *name, u64 dst)
+static struct bkey_i_dirent *dirent_alloc_key(struct btree_trans *trans,
+				subvol_inum dir,
+				u8 type,
+				int name_len, u64 dst)
 {
 	struct bkey_i_dirent *dirent;
-	unsigned u64s = BKEY_U64s + dirent_val_u64s(name->len);
-
-	if (name->len > BCH_NAME_MAX)
-		return ERR_PTR(-ENAMETOOLONG);
+	unsigned u64s = BKEY_U64s + dirent_val_u64s(name_len);
 
 	BUG_ON(u64s > U8_MAX);
 
@@ -197,11 +195,35 @@ static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
 
 	dirent->v.d_type = type;
 
-	memcpy(dirent->v.d_name, name->name, name->len);
-	memset(dirent->v.d_name + name->len, 0,
-	       bkey_val_bytes(&dirent->k) -
-	       offsetof(struct bch_dirent, d_name) -
-	       name->len);
+	return dirent;
+}
+
+static void dirent_init_regular_name(struct bkey_i_dirent *dirent,
+				     const struct qstr *name)
+{
+	memcpy(&dirent->v.d_name[0], name->name, name->len);
+	memset(&dirent->v.d_name[name->len], 0,
+		bkey_val_bytes(&dirent->k) -
+		offsetof(struct bch_dirent, d_name) -
+		name->len);
+}
+
+static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
+				subvol_inum dir,
+				u8 type,
+				const struct qstr *name,
+				u64 dst)
+{
+	struct bkey_i_dirent *dirent;
+
+	if (name->len > BCH_NAME_MAX)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	dirent = dirent_alloc_key(trans, dir, type, name->len, dst);
+	if (IS_ERR(dirent))
+		return dirent;
+
+	dirent_init_regular_name(dirent, name);
 
 	EBUG_ON(bch2_dirent_name_bytes(dirent_i_to_s_c(dirent)) != name->len);
 
-- 
2.41.0

