Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB0610E5
	for <linux-bcachefs@vger.kernel.org>; Sun, 12 Nov 2023 00:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=quora.org header.i=@quora.org header.b="ND4G2PEV"
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3430D1718
	for <linux-bcachefs@vger.kernel.org>; Sat, 11 Nov 2023 16:39:11 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6ce2988d62eso1944026a34.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 11 Nov 2023 16:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quora.org; s=google; t=1699749550; x=1700354350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6SMdZhVnZz0fqTFpbpWpMnfjrZwQQWUBQ+09KRZM6bk=;
        b=ND4G2PEVbqlRJ25gI11IFRVvGxJww1OY9oS90UtCWRpp/j5wsBzUdZDQfyvB5MCmPS
         DcWKXPCROIT4HYEz2jDA9yuRmcIDYmLzk7ldoOYT3voiFDMjRYOzGcTSGGVU7SIJncr3
         orJ5n0CrMjh9W8hQz38aUV6PZ4qJYR0bBLDTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699749550; x=1700354350;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6SMdZhVnZz0fqTFpbpWpMnfjrZwQQWUBQ+09KRZM6bk=;
        b=Xc9T0CaJE0q87J9edQyWyjgG3s1GSLSUnzWi6jNiAkf6fJ8rqeZTWfHV6aVxJ9Eo8m
         aIS9gjHUzZNkkuQBCBBDmO278tP3H4d6euhUr/HMickerF5kH8WOOCms8WtdAERMsl1+
         wPpRdOrAvVSLX9XMnGQ2Y45UONVWXvVB8cHMSnT4eKBEkddKCfVEZ6DlWn+wp3gz6Zz2
         fP/tyJ9xXiptIy5VIOteJKsI00ypy38YLWXYAcDOQPCOvnaTc7jrpu03Jij15OrlVuJH
         eCzj1lTqw+2IQ55Za8X+fnhx9oCvVgSYwLApae3bxN0y7GYgUbPkx0Bpn13OfUgEA14o
         TGmQ==
X-Gm-Message-State: AOJu0Yy1Mj0FaCHPqqStdUaaqScLCKddq4lhK9smjpKoUZbH2zgFLIAH
	6miN3DemSZSkyJoDb0c8BRgMVAw/nNM7Ze27Wnw=
X-Google-Smtp-Source: AGHT+IGND5EiY5rsM60+M9msCw+cxltmVHYmIfuK7Si2A9gvKX0asaZh1RIgrJ2nVqXvCxZ2VAtkHA==
X-Received: by 2002:a05:6830:3499:b0:6d6:4c25:5a56 with SMTP id c25-20020a056830349900b006d64c255a56mr4958073otu.12.1699749550442;
        Sat, 11 Nov 2023 16:39:10 -0800 (PST)
Received: from nuc.. ([202.83.99.71])
        by smtp.gmail.com with ESMTPSA id w23-20020a170902a71700b001bc676df6a9sm1789682plq.132.2023.11.11.16.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Nov 2023 16:39:09 -0800 (PST)
From: Daniel J Blueman <daniel@quora.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daniel J Blueman <daniel@quora.org>
Subject: [PATCH] bcachefs: Fix potential sleeping during mount
Date: Sun, 12 Nov 2023 00:38:41 +0000
Message-Id: <20231112003841.20186-1-daniel@quora.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During mount, bcachefs mount option processing may sleep while allocating a string buffer.

Fix this by reference counting in order to take the atomic path.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
---
 fs/bcachefs/disk_groups.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/disk_groups.c b/fs/bcachefs/disk_groups.c
index 1f334124055b..4d0cb0ccff32 100644
--- a/fs/bcachefs/disk_groups.c
+++ b/fs/bcachefs/disk_groups.c
@@ -555,6 +555,7 @@ void bch2_target_to_text(struct printbuf *out, struct bch_fs *c, unsigned v)
 	case TARGET_DEV: {
 		struct bch_dev *ca;
 
+		out->atomic++;
 		rcu_read_lock();
 		ca = t.dev < c->sb.nr_devices
 			? rcu_dereference(c->devs[t.dev])
@@ -570,6 +571,7 @@ void bch2_target_to_text(struct printbuf *out, struct bch_fs *c, unsigned v)
 		}
 
 		rcu_read_unlock();
+		out->atomic--;
 		break;
 	}
 	case TARGET_GROUP:
-- 
2.40.1

