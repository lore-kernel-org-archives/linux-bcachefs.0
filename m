Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D00C1DA5F
	for <linux-bcachefs@vger.kernel.org>; Sun, 26 May 2024 19:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716750521; cv=none; b=MqjowVdKYFEBz9ky0rYiT7K+5vCrA4MsNRtOxG2b+O1qakBQn3FpRGNAJc8I6kDXyot1aPE+b5QmN8PZDl0rkzc+tAv7Wr5WFbooSyUte06EuaFau6oSm+kB8Af5a3yJk6QdFgXSN/ZU8uM1i4bIzst3ECxlPVIzZn1axmfLky4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716750521; c=relaxed/simple;
	bh=iXUfwRkvdwZzU9RhuLo+9zRO+zi3QTvs0MIIiJw4uW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCtKitoVWgQ3XgTtjLYjKdm8tG78ETvaCXZ797+VuqSgG+wj5komZhFz73KzuUucYNozNbYjesbEcyjyGvHJMvMB4HyFZPNuR9UlRxogxLr0aAX17UZMTKhnBwo1ty83EUd8yGFKt278bZAKt6dNZvANTNpjOBqPoaSlSXNMIaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pubhh51D; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pubhh51D"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7e97d38584fso87030839f.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 26 May 2024 12:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716750519; x=1717355319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WkcYoNLmIQWo6OOTlwSZrcuj1ZwoqSxjQ4pM8lwIEu0=;
        b=Pubhh51DHJFHHMWdnC/nvamcFVD4vhlVEjmAx3o1+zyZK8nAZ7VZsPNq3u+55lM0/H
         RN2lWkeqAkT+oStgIy5k0YHRIIJSQxBLz604U5j3gxTmH+hsADP18dFDL3JIJ8Tz8Qwh
         AKR9kTXZF7kxhj8hQfAe+b+RGgX3az4+jm2dwyNie+dWHGCsajzMNKeZAP6ZoYNKVqFU
         XszGlRCjmSQOatDPHj4jscdM1ql6wXO9eLgAg2Jwfbk1vnc8hSDW4IgHiWfdNaV7nNRw
         /2I1atN8DalMrd2ZAaywQtrn8cdfSwxxokfHweWRDgN8XXMjkBTGIgdtX9WAtPMByPHp
         6x+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716750519; x=1717355319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WkcYoNLmIQWo6OOTlwSZrcuj1ZwoqSxjQ4pM8lwIEu0=;
        b=lTvd3oOErwBFQ2G6JgkoFdCUTCGPMsx1WmDM/1CbuXAxaiGMvPRjMnu6srLOg4fwKu
         BCIA1iEpF6GYCx9nVKIG6J0CU1j9lq0iicZdghQQBvyVEdcLUDJcVlETjMuFnXMWj87Z
         75qnKWVckenVmhFcOfJ7g18vTCZRxTlez9wmaKSLdByoF8tBg+9wVKQQn9RTopKtksO0
         AohhfZc9BTOAJ8YgHk3KKwe5880TkTR/K4cxilU5iWRpcc0qGu6Msr+0P5NbNTwFVpIL
         Jb8mzDDPouTYrsCeRS8Ehlszj3yFhHj7b+3O1B8fVKqvnGsZAU35DNLGcZrM1ZOXQI/2
         XMbg==
X-Forwarded-Encrypted: i=1; AJvYcCUhbJgKWSSH2q1OKnDsbvcs3bZ0GtSbbrpuWebsSZ5xuBQhkfz/kyIZtuVW3CkTywyyPR4cX17RmM4+vCXDfCBzjIktl3RtOlfLwLHFlcU=
X-Gm-Message-State: AOJu0YxW7Y88fifnLFuz0C72KltuVBRCiLbMD4j7E3NsXKYkFz9KQHfU
	CBi+mpi9bA8jwthVBdfUgO5gQocBiG1PFUdbBmhahGa/DydTvF+2
X-Google-Smtp-Source: AGHT+IFLCm6zcozk1TSorj1w9ll01BNEqFp3NeMp+4hXlhSA2UvmD8TO/CfhKQuBWOC8uJz7YQnXpw==
X-Received: by 2002:a05:6602:2596:b0:7de:e528:2c6b with SMTP id ca18e2360f4ac-7e8c6559a20mr1079063339f.16.1716750519140;
        Sun, 26 May 2024 12:08:39 -0700 (PDT)
Received: from fedora-laptop.. ([206.85.159.137])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b03eccee6csm1656056173.148.2024.05.26.12.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 May 2024 12:08:38 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH 2/2] bcachefs: don't expose "read_only" as a mount option
Date: Sun, 26 May 2024 13:08:20 -0600
Message-ID: <20240526190820.606162-2-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240526190820.606162-1-tahbertschinger@gmail.com>
References: <20240526190820.606162-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When "read_only" is exposed as a mount option, it is redundant with the
standard option "ro" and gives users multiple ways to specify that a
bcachefs filesystem should be mounted read-only. This presents the risk
of having inconsistent options specified.

This can be seen when remounting a read-only filesystem in read-write
mode, using mount(8) from util-linux. Because mount(8) parses the
existing mount options from `/proc/mounts` and applies them when
remounting, it can end up applying both "read_only" and "rw":

$ mount img -o ro /mnt
$ strace mount -o remount,rw /mnt
...
fsconfig(4, FSCONFIG_SET_FLAG, "read_only", NULL, 0) = 0
fsconfig(4, FSCONFIG_SET_FLAG, "rw", NULL, 0) = 0
...

Making "read_only" no longer a mount option means this edge case cannot
occur.

Fixes: 62719cf33c3a ("bcachefs: Fix nochanges/read_only interaction")
Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/bcachefs/opts.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index 25530e0bb2f3..f902793e1810 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -406,7 +406,7 @@ enum fsck_err_opts {
 	  BCH2_NO_SB_OPT,		BCH_SB_SECTOR,			\
 	  "offset",	"Sector offset of superblock")			\
 	x(read_only,			u8,				\
-	  OPT_FS|OPT_MOUNT,						\
+	  OPT_FS,							\
 	  OPT_BOOL(),							\
 	  BCH2_NO_SB_OPT,		false,				\
 	  NULL,		NULL)						\
-- 
2.45.0

