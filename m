Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F44786353;
	Wed,  2 Apr 2025 18:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743617775; cv=none; b=fB83aDhd6zNDFCGKEjnvvEo5FSLfBYK6fa9S/GDTvVKocaxjdIxMDntnzax0gN9cKB+Gkl4uEujKgi74IDX85A0peifY9LGhcaBNVQ7kh3ZxGhsMkmqtE7es7FUDzh7N/qPaQPMgSEpaPUqEN4k2I0Ur4DeiJ4LDC0epYrNuguQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743617775; c=relaxed/simple;
	bh=DIH9ivi+lh/hzgbKGXNvqFzCJgtGWKWEU6a5nsjLyUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mZZSFZpYbTO2cLxvJ0AzqhGO/pIvlLBviV7HbdX/B9JbqKvRDu4f2MQaztnWcAa/JMfybe7FlxzqS70UAAHRHvrYB1+8nDZwRNVN19JNaGkhcLPjPkXSEViSsJg6geUN639X65PDDTSWFDW6X9NjH/CeJZdM5wqivevc7LiLtbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HmGAxVzg; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HmGAxVzg"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7fd581c2bf4so109927a12.3;
        Wed, 02 Apr 2025 11:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743617774; x=1744222574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=x0TdMKNGPTVum9Gw2uyoKM+R1Bk/OCWS7Vd5opsWj9s=;
        b=HmGAxVzgDoNQeyrTQctH8Bk2u33GDx7DbzqiYER+a9P7cA5qRIx9hmj3b/o3JkfzF1
         yQirISIqX4ujeqcb7qiereMPfbGzS6F6l55/GBIFdAVh/UzytulaUrYFDzlLL5dtFEDW
         r6uXyJlR/Sy48cQkcUw2O5Vi1Ux/uxoOyZLFNRi9VxOb5PCVTadv/pEyGdqDMNo7Om+T
         d26o/q6/DH3dgrUW6ToBzQ3En1gJmW3tdev2JugQ1aBNb0ahZ2dJCx6kzrQvWNcxqZOo
         ERzxitjQp5EM/7QlBrPMl6LYRApKrJ2dZDLhbt/I4sSwju49kd3SngpuC4iIZRmQuSOI
         I2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743617774; x=1744222574;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x0TdMKNGPTVum9Gw2uyoKM+R1Bk/OCWS7Vd5opsWj9s=;
        b=qLn7QntTHifjxP5Y8+uPVNAznPawTzMvWhrrJO6FSTdXj7lqeZ341HGIQSWTmg9UxJ
         oLlSYf+BRYLJOuv5xFf/8It0rL+8boXuoqdANT7L+7FhOpc5zdOpjGMJvakIZNLBG57f
         /+Xfmfh6HuPBGmTSOOWU5T/We9RJc1dZsC9/ma6UwWsd+PeLMcrwdZuVXCM6dm2L8rjw
         /NGJFxVSnXyUBaef07C983/U9xMGosrKIsIHjnhsLwGbYrx0Gw3NrF1VHBii+v95ddtV
         l1zSaojid58m/F1rJbIjr7Jp8fETt9XOucUl+JGLeCXCSAqjXhfQJIJr/Ll45IbNUN5q
         NP4w==
X-Forwarded-Encrypted: i=1; AJvYcCUIWgSMSSA6IMtti/30RzzLImM8r8cfMXhlqwaakI6acFARcalRjRalbWkgVISfacl2wPXtRaAa1mXptWgX@vger.kernel.org, AJvYcCVh0e6OjA+8i78OE3tPHff9IpOumE5OOtauqD6V9WTjeVRSFEeB+bGHGMQG7Fm2xx3vT/Xs/a5vkgWNhbyehw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRfuNTEbkERdkcOj80rIRzlii7D2SWxoVqgYEMQs541NSoKjoV
	xo64qZan1NSFcpDUcYPNbBC8/OrCvqJpbSyolFQe7+ivHdqSLdWf
X-Gm-Gg: ASbGncsCs4ORYf4KCqojxUe/9BXV9ND9cqgcTceQJPT8BADYrNZaa3qKhfs/dTnnXBS
	FeDPCVQnVyu62evU9MqJJoLJamOf4FLm6aqBSxHWrVk91knPsN8QqhF1bD4hSQMyN15+QP6DDwb
	PGiN/mWBF+JiN551ETYc/CFy6ga1OviQS0VS4QG+q48HHG5fwEAL/duAUYYvL5xXwlLN0sDZ3Cw
	Ord23y5zeK8fcFoQlRBTma/obfcXIXnt/hxC4EX38PrA1UfTvI35SD3wXZRGSGg+uFLz4qcxlC/
	FwgfFMNtXtqLZj8JtJ2fI5iXNfqC3tHRTbXtl5M6+XTHwCF1k12tSulgs8/s3xwPCA==
X-Google-Smtp-Source: AGHT+IF0oea4zc4vg1J+wdlW4qiDKMUxbE8/u+yBFJthNc7Rd32uz5JsdoUwKx3/CjqQ5l3svlkACA==
X-Received: by 2002:a17:90b:3c4f:b0:2ee:f550:3848 with SMTP id 98e67ed59e1d1-30531f7c573mr23548735a91.5.1743617773656;
        Wed, 02 Apr 2025 11:16:13 -0700 (PDT)
Received: from localhost.localdomain ([14.139.69.34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3056f888d3csm2151378a91.29.2025.04.02.11.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 11:16:12 -0700 (PDT)
From: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
To: kent.overstreet@linux.dev
Cc: Bharadwaj Raju <bharadwaj.raju777@gmail.com>,
	linux-bcachefs@vger.kernel.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev
Subject: [PATCH bcachefs-testing] bcachefs: use nonblocking variant of print_string_as_lines in error path
Date: Wed,  2 Apr 2025 23:45:53 +0530
Message-ID: <20250402181556.81529-1-bharadwaj.raju777@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The inconsistency error path calls print_string_as_lines, which calls
console_lock, which is a potentially-sleeping function and so can't be
called in an atomic context.

Replace calls to it with the nonblocking variant which is safe to call.

Signed-off-by: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
---
 fs/bcachefs/error.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index b885bd92834c..baf5dfb32298 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -34,7 +34,7 @@ bool __bch2_inconsistent_error(struct bch_fs *c, struct printbuf *out)
 				   journal_cur_seq(&c->journal));
 		return true;
 	case BCH_ON_ERROR_panic:
-		bch2_print_string_as_lines(KERN_ERR, out->buf);
+		bch2_print_string_as_lines_nonblocking(KERN_ERR, out->buf);
 		panic(bch2_fmt(c, "panic after error"));
 		return true;
 	default:
@@ -71,7 +71,7 @@ static bool bch2_fs_trans_inconsistent(struct bch_fs *c, struct btree_trans *tra
 	if (trans)
 		bch2_trans_updates_to_text(&buf, trans);
 	bool ret = __bch2_inconsistent_error(c, &buf);
-	bch2_print_string_as_lines(KERN_ERR, buf.buf);
+	bch2_print_string_as_lines_nonblocking(KERN_ERR, buf.buf);
 
 	printbuf_exit(&buf);
 	return ret;
-- 
2.49.0

