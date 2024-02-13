Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96171754E
	for <linux-bcachefs@vger.kernel.org>; Tue, 13 Feb 2024 07:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707808424; cv=none; b=Z45QGIPWo8uxFZFpwx4gH6bHdx/G1hfaxPNYXwBjqiWG03YuaDRHtQSj466Ekoj3GH9ICMedX9AfUZcUJVIlMLLFSbYZykHIAh62xV0XGwcH2V4s2KGIZc/C+Lm5WpNVkbz+qL6MeEPDoUkXK+SRMqpHn9yY001we/FfV0ZYkgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707808424; c=relaxed/simple;
	bh=HC5oxnvLDhimRYxt1ZIg5l1R/iERiejOJwdgBEHthG0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uZD5nf57bh5I58eBi2uMbVT4n4Q2t9qZFclXtd3DbahRZAaxF3CFg0RkCcnFO5CLO+ow1yDL2hnlwKczGLsQPSKIPLPNCzqMoJAn/HvLzH3QfSVhdKEB66JhGKpdMRDb7EPfsiUYuBA32niroNUWB399K132RlQnyBNwtIXzfpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EDj/9VHx; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EDj/9VHx"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e06d2180b0so3245639b3a.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 12 Feb 2024 23:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707808422; x=1708413222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vs5GOZxnoNDNXWYUZY4S7Osy0LfjnN6WodXLV56Dr4c=;
        b=EDj/9VHxbO9cuzJ+TL0ezUP/i6bihRlbk5W1fElQE8ssRbR8zBiAxKojJUWHxVlkMk
         y6S/KWBS2Z7SUDGNEs34MeNIGv1ZAGlZYINKD2j+Y7KnhlT+BYSQEziPaK20ypE74beA
         oisafmv31YhhaYxsT8n1nQm34XssfrS8oOtQy4K7NYVPtEKVpyAMSpDpldH8l4+vQe37
         vE5mifk1CZyQ4RMJki1BxMvXa2v1c7PXd4aAHeuPndC51RAVtpTgl/W9Ue/hPveX0h2k
         eztv8iqNxae0qAWFEv1AkjtyC83rTarkbUvrxRFJ9PXEG8JpNnopkbCEr15nTIK0hSTv
         oDXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707808422; x=1708413222;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vs5GOZxnoNDNXWYUZY4S7Osy0LfjnN6WodXLV56Dr4c=;
        b=U1ySDZNYk5FwxE567fyNjcMOUR4pTqhMGRyN/5O336qfyglC2AdjfSywkw3BdEP78C
         9sDNE5mrwJxjxMtVkWKuRiuTbCHtsQ1/FF3upOqVJ3gZK4E7oOkTQV9Ajx6bRffmn8a1
         pv8l03EYYT/H/MtgpoYg6lG1aAW8kxXAVNNRJyEkGXEiruSmAqh/YOaAeIpm5tmip5Pp
         QPNQaO5rmu7UWJMoopCUtml6nQBb0DXjLpNjvYt14FGvvdV94zjd/Y8e5qPdObzOA5sp
         B878AaotmPjHsZ9IWp0vb/KhVdySkGXNENKMzEqw4jT4u+aLTe9sTWIrNQnaMWwITokM
         7BsA==
X-Gm-Message-State: AOJu0YwHY1u9SXlmbg1JymLotwa2qILlaqXsIG3psuZo+ZXFqqyzlddf
	G0aYnYa8nqZE9EnrQ8aTqWnNz1uAj4ntrD8ZD3fBk8Bp2nN+nYGl+LSaYiN75OCdgBTd
X-Google-Smtp-Source: AGHT+IHLrVcf9tRVbKk/sH10D8daPpPVhdis821RI4oFgjkpiTNMvjWatKV05XQQ42wl/M+5RMrQFA==
X-Received: by 2002:a05:6a21:8ccb:b0:19e:be98:fc68 with SMTP id ta11-20020a056a218ccb00b0019ebe98fc68mr12491746pzb.52.1707808421993;
        Mon, 12 Feb 2024 23:13:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU4b+SRyoOMFtxNL4ktND5kVFO08WX8mZAQL+i4OOf/ehLDms8DJTl5Wq1+FjbIUfaTTaNjFuO4RmYf3wOCs4jZ
Received: from localhost.localdomain ([8.218.212.108])
        by smtp.gmail.com with ESMTPSA id ph8-20020a17090b3bc800b0029899165611sm1200593pjb.35.2024.02.12.23.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 23:13:41 -0800 (PST)
From: Guoyu Ou <benogy@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Guoyu Ou <benogy@gmail.com>
Subject: [PATCH] ktest: add a test case for rmdir empty snapshot
Date: Tue, 13 Feb 2024 15:13:25 +0800
Message-ID: <20240213071326.12699-1-benogy@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Guoyu Ou <benogy@gmail.com>
---
 tests/bcachefs/subvol.ktest | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tests/bcachefs/subvol.ktest b/tests/bcachefs/subvol.ktest
index 1915d84..4a50da2 100755
--- a/tests/bcachefs/subvol.ktest
+++ b/tests/bcachefs/subvol.ktest
@@ -718,4 +718,22 @@ test_subvol_mv()
     bcachefs fsck ${ktest_scratch_dev[0]}
 }
 
+test_subvol_rmdir_empty_snapshot()
+{
+    run_quiet "" bcachefs format -f ${ktest_scratch_dev[0]}
+    mount -t bcachefs ${ktest_scratch_dev[0]} /mnt
+
+    cd /mnt
+    bcachefs subvolume create ./sub
+    cd sub
+    bcachefs subvolume create ./sub2
+    bcachefs subvolume snapshot . ./snap
+    rmdir ./snap
+
+    cd /
+    umount /mnt
+
+    bcachefs fsck ${ktest_scratch_dev[0]}
+}
+
 main "$@"
-- 
2.43.0

