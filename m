Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B362554BE7
	for <linux-bcachefs@vger.kernel.org>; Sat, 25 May 2024 19:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716665789; cv=none; b=UuMzJrG7U1++JM3mgXg1F/x9ZjKrWzu4NBGydkp3tQRAGsAdo9YnzIlsyULZXOczUC4h4NtaTwL0mn1wLsMKfn6/oEZSMALkgw2ahTSgXXzGTmUdTQFuWSmhTdtgauD1NWFMyUV172hJN3XuhRjimpOFecHtYSyCGuuwbza0MxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716665789; c=relaxed/simple;
	bh=LewTphtqA2pAUtC23p2CTIOJqofx2iFRS2DRjlHvNGM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sT1RQj//rnDkyyD2vsKIZ0qv6ZnZTR3GJtX8zYBEcEfOwqo8fOsJLOokFMojk+wHfRCn3KlIOg71LDn2OZsrNdzb3t6SanNZLKDpHOsOmvbSfCV6rUjHH7AYvZtZ59IlbJCgTlf4BtoOZuD2JrL3ppSA0pqA9MJst9SwBS4+Djw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LoVc/FEl; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LoVc/FEl"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7e1d0a674bfso138765139f.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 25 May 2024 12:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716665787; x=1717270587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zXfeJxyzcITkR8P+gjINNea3HzqlDWSTuvHEpaqcHNs=;
        b=LoVc/FElhJIeXVN7pG14BFGq9oqvCoygw5WgfFZ8KXZun4FlA3oimlJMdoZ6JrcOsd
         EGBKUadYBd4mYcdYWualJg5OI6mx/+9NRIbp2kZeEeLailbXRV3Sd2dJyOdU7JpG1kLO
         bTM0pGqKjbsdlHvzSFnz54k1d1Ps63A+PjbtMK4MTncwjF4gPI4yTUwRZlNKHTX5ykeA
         dwAZKOZoBy8A1rC6yVw4jBRfsRPr3+tufRJqao2zK3wZVHSzd6GspmfxfjiI62g7eCvk
         MuBD0WaeOmm0KoIbKbFMJMhaDA/fMPu694C+SI4Yk7HFsDYu3STIQ/1bYL9qna4PrmBs
         Te/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716665787; x=1717270587;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zXfeJxyzcITkR8P+gjINNea3HzqlDWSTuvHEpaqcHNs=;
        b=nLCUtgx3pt1+WZQJkESqTSrFAMqRfrTBTgAhkcyH/fEqNsz8NU239ATsuofS9qKqb8
         S/qajSC2jN0iVfVjv6S461eowag6oAyaZnPhCATBEkYus97WruxxvkiqzUFm6vlOnqOD
         anpJ3g94p2YBYGu1k0mZJlPAtUu2YQDWGRdoYZbbkXvtdSDhLlSs/ZenCQ4cp6DOPqx6
         Kb1dWiwWbPPKDWx5yqFnCZj6QcMTo+ypcB8Kob+5r1glUJQyLi2ASm7tqj6PgfmufFUt
         M3iw4xikGNh5j31naLO+u0wNBoDInwycvYXt45GIz87VqiiCorBNMm4Is82kBkAhz31i
         /a4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWETxlaEVbgJSrJLLB6IA7N7RCta8046+tykACs7DinTsqwB31cL+eIuCJCrAPuk/U59tdn7Rr/HpErolMAgfeiqxvF3C93bBRGLQfujZs=
X-Gm-Message-State: AOJu0YwqCEmyd2vqy/dvqYUNY2JUrb1hJohFqlcIBPOlYSUJjJzKMAjy
	/U6BI2pxN7ijZ33bQz7+6a4D0zMNHRKPoCxjdKnEYm6Cc16VL3a0yqM5Tc5dARc=
X-Google-Smtp-Source: AGHT+IEDBHB692tdpxK6rlAL73qxSpSK3h3+TbOzXiMJlFxe//ZE/iPf4ZKGuJmoivoAARDQ9KCxSw==
X-Received: by 2002:a5d:834b:0:b0:7d9:b860:3e28 with SMTP id ca18e2360f4ac-7e8c4ef52c6mr407685639f.3.1716665786600;
        Sat, 25 May 2024 12:36:26 -0700 (PDT)
Received: from fedora-laptop.. ([206.85.159.137])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7e903e0b66esm94371339f.3.2024.05.25.12.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 May 2024 12:36:26 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH] bcachefs: allow passing full device path for target options
Date: Sat, 25 May 2024 13:36:19 -0600
Message-ID: <20240525193619.401336-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The output of mount options such as "metadata_target" in `/proc/mounts`
uses the full path to the device.

mount(8) from util-linux uses the output from `/proc/mounts` to pass
existing mount options when performing a remount, so bcachefs should
accept as input the same form that it prints as output.

Without this change:

$ mount -t bcachefs -o metadata_target=vdb /dev/vdb /mnt
$ strace mount -o remount /mnt
...
fsconfig(4, FSCONFIG_SET_STRING, "metadata_target", "/dev/vdb", 0) = -1 EINVAL (Invalid argument)
...

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/bcachefs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 2206a8dee693..864c216346a5 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -2029,6 +2029,9 @@ int bch2_dev_resize(struct bch_fs *c, struct bch_dev *ca, u64 nbuckets)
 /* return with ref on ca->ref: */
 struct bch_dev *bch2_dev_lookup(struct bch_fs *c, const char *name)
 {
+	if (!strncmp(name, "/dev/", strlen("/dev/")))
+		name += strlen("/dev/");
+
 	for_each_member_device(c, ca)
 		if (!strcmp(name, ca->name))
 			return ca;
-- 
2.45.0

