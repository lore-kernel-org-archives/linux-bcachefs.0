Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7827D1B6D1E;
	Fri, 25 Oct 2024 11:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729857395; cv=none; b=BPsIChgS1iU2J/SSvySpDfNle065sGAxQuxFYwJf4ATd427dx7CKlJYL56PxH5JUJvvBo8urN9l4NkhvM0cMZrWtY9JsBBZj8YAi3H7x27jPehpygqTflXlH85GrV4zZtZaNecgi8g0UwcP1WjqoqRq4eKhbcCnpYsy/9tMPiUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729857395; c=relaxed/simple;
	bh=6HqTo/vuQ12dw/8DMCMepPCaa6btVdh3kQW8Yveq/xk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ErSOdjj8kKoLcyOsqFf7l5WMdjVdK6wdGL1TOP0GVHuqOGXx2MvEMkM53gkNF2p7yMTmZtmXP4DndpPCNO2YGJD6Wm0c6UZGTMXto04hceaQLGDg3qPZG/GwPUoH9aCX2bG/PNstsfOOgzfQ/wfdYSNjDK+PaecVu77iGQBYmsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kijh+oDs; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kijh+oDs"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7204dff188eso928063b3a.1;
        Fri, 25 Oct 2024 04:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729857393; x=1730462193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Jtuzcx/hdWcvqRVO+awpwiv6gXjX6atu7il7J/8W+2E=;
        b=kijh+oDsNeLb5WzdFdEyFO31C58Cv6PuqRlkwPBimI2vIKdcdC2bxV73RgmKsskFtu
         SZNSJqigMd29umj7EJnLKKm6KM8/tUxIKVu0ccLmUeDjbbOrTDjmz++suLXVtdYNHSKb
         x/1uBnzw3IkfKnLZClNxQf7iFe1ZV/zBrM9i0mYyCojl1BeU1DuODgGa4XGjbJq3UKG+
         WfZ1e67dw5H88NJCRPwTP4jryE/FCZDSe+f/zVIgFrv3XRz+VzoI1vyEldzd3YSSsn46
         OgA600KKA7D6cwtcy4S6YdzdVfzBLr7A0RBbHROTbU+8HBXEBW/fYq5SbvirTzmbQVGE
         /RRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729857393; x=1730462193;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jtuzcx/hdWcvqRVO+awpwiv6gXjX6atu7il7J/8W+2E=;
        b=UzLTRAw0X+1oUpOUoiTwaGb4cZ5g/BGCsUg8vKxc6WXz4Z2yj3BypRi+oK3kKfT+Aq
         wrMnHrXgf3FZd3ySgvbm6cs46omy4TO0jvF/6WwqVzjbzg0gQCch3rNoJpsP8JgWcVLY
         4TB7/5mn4zjFR0+Erxz/SlQoD63Iki/LpAEYasxSps9bYldP2ziQSHB7RzVySrsLeS/z
         j9IYwj47Iq5P4B3lX5LbpshU2zP8HHqLcruu7nqq02MdXpLbBal3pgrEUsF6vl8J3b33
         i84B462hHyBYfNTSG7VxvO9ts38Sn4zRBnwvF0Q8PWnzdsDexyRNOxVKaiD6pf4gv0vs
         lE2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUpu5xSWIDo/yoBd8zwZbSO+UmH0LeE09TPsIUs8QPn2nX8m62G/xtxsmp43RmnwAcZjqt6enz+q9OsFjw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwUoVBkGfE7CV9T8Xx8+X32590tQuHEvvbVofg1fkSYBQcwbSe
	9PcEjYep/+e8xlwbREuMfKwIqjUgnMZ6mJKyy7pqGorIFV+nCgkM
X-Google-Smtp-Source: AGHT+IF3y9KZ65luuZBemliAlnSB7asdtvZRjwl86FCjOLiFWv/tcBwE39EqJ/JoFeUleIdzn2CnkA==
X-Received: by 2002:a05:6a00:852:b0:71e:3b8f:926 with SMTP id d2e1a72fcca58-72030b677bcmr13363511b3a.22.1729857392634;
        Fri, 25 Oct 2024 04:56:32 -0700 (PDT)
Received: from kernelexploit-virtual-machine.localdomain ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057a3da8dsm911687b3a.195.2024.10.25.04.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 04:56:32 -0700 (PDT)
From: Jeongjun Park <aha310510@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+b468b9fef56949c3b528@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH v2] bcachefs: fix null-ptr-deref in have_stripes()
Date: Fri, 25 Oct 2024 20:56:18 +0900
Message-Id: <20241025115618.2908-1-aha310510@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

c->btree_roots_known[i].b can be NULL. In this case, a NULL pointer dereference
occurs, so you need to add code to check the variable.

Reported-by: syzbot+b468b9fef56949c3b528@syzkaller.appspotmail.com
Fixes: 7773df19c35f ("bcachefs: metadata version bucket_stripe_sectors")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
---
 fs/bcachefs/sb-downgrade.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/sb-downgrade.c b/fs/bcachefs/sb-downgrade.c
index ae715ff658e8..8767c33c2b51 100644
--- a/fs/bcachefs/sb-downgrade.c
+++ b/fs/bcachefs/sb-downgrade.c
@@ -143,6 +143,9 @@ UPGRADE_TABLE()
 
 static int have_stripes(struct bch_fs *c)
 {
+	if (IS_ERR_OR_NULL(c->btree_roots_known[BTREE_ID_stripes].b))
+		return 0;
+
 	return !btree_node_fake(c->btree_roots_known[BTREE_ID_stripes].b);
 }
 
--
