Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91A710F1
	for <linux-bcachefs@vger.kernel.org>; Sat, 25 May 2024 04:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716609639; cv=none; b=eJWZIvOHx7Fr2R2ZZMWr+6ubgke6tILUirWjOk2bHPtiK7nzMcRpgR0Mpo0ZpnQN+AaNj6vJuryEkUphp7ut06Kv19GMA9Oq+Fmubv5w8BBBGqdZDmI3lAZFsBm5hv0qRfzRblb+55OSZ7iMzdcS81ICQJ/4P8+aDcgEidtxt7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716609639; c=relaxed/simple;
	bh=qqLZT+8GFFKxf8NpDQsoLL6AcX0WCihbpZ/JWgjEKo0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kAFJEqpaYEKw2BLIo+ad0C72CL2okzyve2XkS2cYaJtOJbLmCpftRaAmRghcDHRVR+Xu4qXf1wxmse9tJr9dACQx4NWBnsGtAF3kCqBje4NGScfAzu+LR2FuTfOn9lzovCHwsFCS3UrzTmZrUout+Pp7uhR6UhdP/qWdF4K6CLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oath8Zob; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oath8Zob"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7ea7d9b1d69so5578539f.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 24 May 2024 21:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716609637; x=1717214437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PRuoIlLT/KVT9z26cAiviRzaVlTrcTHJZ7f5QNYZ4ns=;
        b=Oath8Zobg++vYH/fJ40UqhdVh457wAWtvleQPnYVU3ifTtO6UBTdGpBhFJOduzXUSi
         jX1YwVAlyAjUtkBglqq+oL5KCagDZf8OZqgVsdzv56wRb/7f48bqZTsZu4eClIGkjbhq
         E9KjJZG1ieO6ksb+mtRw9GLc0oG4lPxzm2tiHivEiQ3xU4VOSQcl7Mmyu0kD7G10xL6H
         f7rTrXZalaxS17yz8bdA6oPSFs4V4/aX97Cmhgsc+kQnL8v6CQqse9KKxO7mlWfnK5hX
         7a4aJ+pZbepeW9kKWLTeged+H5uKeKkZzNl+O4XxnComm5iIAP3LLJx0LJskjrXdTq7v
         ymJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716609637; x=1717214437;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PRuoIlLT/KVT9z26cAiviRzaVlTrcTHJZ7f5QNYZ4ns=;
        b=D4sV2aKfO9J5o73KWZ6SHs1sgJPKqPTaCFPdZVtdbhwPdwzjHCqq1ILpWGyMAcbUGg
         eu7vQH45GHWtrfi6lwwMiPWrZxV1dp7vQl5ILfuBj26dcK3rlFP45S+xf8VqHjDZ+ht9
         PfPxhwJbMG/c+aowi0BxwP84/mQ9yX3U90RKDZiaS+X+BvW4XgRQeXcUoEp7z/GZrdk2
         KdkoxJxKtDQlxcOul0GONFMsxKPTqjbpaPhNVyT4iBQE1M/WxEmDS47FSwyyqb3ZfgFD
         C77Ei/FY+i1jFQj6NoqjlsFJ+U8cQilYHL86W3DHhNec7tryQSJyC+YUTIiWD9rLFcqG
         W1Kw==
X-Forwarded-Encrypted: i=1; AJvYcCUNFOEWFhZqSlcWF4I6ZQh6rg7C6t6GFuGdIdoQh0qZlqh2bpZjMxZGIMumQ8SBeVyI53UAuCxLXiL3k9G5joePA98JDmvDCE0RN3xupD0=
X-Gm-Message-State: AOJu0YwtlC6JNRlzj2m9JxuHHrsrWUKEBbQn0zt1OO4+YcafFuCc5HCa
	JMN1v0bYaVWNjJ1pabAbtUNMPeraaZvQlHUYBJoCJX4jJJR/evyy
X-Google-Smtp-Source: AGHT+IH+5dFc3GXXS6dKaXKTQ7z0pdul+5q+JK3vAzSivX96UWC7dkuAx1L27h3WA6jH1gJP1ZASlQ==
X-Received: by 2002:a5d:8c8c:0:b0:7de:cb15:1b17 with SMTP id ca18e2360f4ac-7e8c53cbddbmr438422739f.9.1716609635410;
        Fri, 24 May 2024 21:00:35 -0700 (PDT)
Received: from fedora-laptop.. ([206.85.159.137])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b03ebbf166sm716270173.95.2024.05.24.21.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 21:00:34 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS] check errno to determine fsck ioctl error
Date: Fri, 24 May 2024 22:00:27 -0600
Message-ID: <20240525040027.172302-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The error code is in errno, not the return value.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 c_src/cmd_fsck.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/c_src/cmd_fsck.c b/c_src/cmd_fsck.c
index f1f4ae89..68d22fd4 100644
--- a/c_src/cmd_fsck.c
+++ b/c_src/cmd_fsck.c
@@ -1,4 +1,5 @@

+#include <errno.h>
 #include <getopt.h>
 #include <sys/uio.h>
 #include <unistd.h>
@@ -98,7 +99,7 @@ static int fsck_online(const char *dev_path)

 	int fsck_fd = ioctl(fs.ioctl_fd, BCH_IOCTL_FSCK_ONLINE, &fsck);
 	if (fsck_fd < 0)
-		die("BCH_IOCTL_FSCK_ONLINE error: %s", bch2_err_str(fsck_fd));
+		die("BCH_IOCTL_FSCK_ONLINE error: %s", bch2_err_str(errno));

 	return splice_fd_to_stdinout(fsck_fd);
 }
@@ -249,7 +250,7 @@ int cmd_fsck(int argc, char *argv[])
 			goto userland_fsck;

 		if (fsck_fd < 0)
-			die("BCH_IOCTL_FSCK_OFFLINE error: %s", bch2_err_str(fsck_fd));
+			die("BCH_IOCTL_FSCK_OFFLINE error: %s", bch2_err_str(errno));

 		ret = splice_fd_to_stdinout(fsck_fd);
 	} else {
--
2.45.0

