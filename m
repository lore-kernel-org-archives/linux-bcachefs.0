Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3181A72F
	for <linux-bcachefs@vger.kernel.org>; Fri, 12 Jan 2024 06:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LhnqMpQM"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3608bd50cbeso23737125ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 Jan 2024 22:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705042685; x=1705647485; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6Yvgk/Vj40T41WexMarF2OTT3WyvmAl+NvWJAbIQzq8=;
        b=LhnqMpQMy0G6/qLquNQvGQc3u9X5yq1A8Opy3HdyOyjkdExMXnNfQ+wLJj0CXGC5Nv
         Yzp4I5xXaLfRd0h9qjlHVz7x6YFZV5OiMgEiei19dkru9ybpjsVKtqWl1T5ueRYIvA2Z
         fiNBCXwrSDB9jQTq7KwXURn3WJZ0lffsOCaOhT/mHO5ZFd3SPoLsQWdfAtfURHfYt/sT
         5U7T1JnvQsqtNo0sfFKfax0PzjLARNuZca8eTgQtIkJtStPanlWvZx52EGBbZe4Asn+Q
         bqYX2GQDAvypjSlcZjCY2zPLQ4yzQ43lbF3Fyb3yivIIeKIaml/vpfsc3I9CLGpARvYl
         IKPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705042685; x=1705647485;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Yvgk/Vj40T41WexMarF2OTT3WyvmAl+NvWJAbIQzq8=;
        b=PGd81fkDe9MEwynx5TQU85dVQCmHR3I+KTP+cpbKoPeFVjAi8jCcrMJVBo0zVpg2l1
         p6DHrkXXVIqsWVcGROvp5cgiLuSIi+XBrXf/3cScS6D/AwiKu5N4aVbUeVrqLPc+tFx9
         kMQtlfKErQ2s1b4ZiD+blbWW9uxKJfHEt94vPTGpoH3/PCyCv5cqDOmnji5lxL81Og0J
         3dWwTgBi4jYh3wv78Wu9t+x3Gax7XWnNWgghjrz68oPXiLmnlutHZt5iKLrnSv49FKBW
         +beupv9Ko5P1/1YamRAX6mHWU4oY37Y11RzexGhkQn67Tj2cfW4kY8d83ZZ3E5+aCdrj
         V4+w==
X-Gm-Message-State: AOJu0YzCYLMi0oqTevNZ8OHU5RboDP+gS+t1M7h+aJaKSyf4I6gK9xY3
	QUs6ziIooyM/TD4hkh5WdIZd1FHXIujn4g==
X-Google-Smtp-Source: AGHT+IGh0N75VMIplO9ogvLV4pLSSTnkNPf2gNDKEMuoPhZcPMZjFjmY5okaUX124c1Xds0j0l7pnw==
X-Received: by 2002:a05:6e02:1d8d:b0:360:6aeb:1074 with SMTP id h13-20020a056e021d8d00b003606aeb1074mr777506ila.14.1705042685054;
        Thu, 11 Jan 2024 22:58:05 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id bs7-20020a056e02240700b003608f3db11esm770790ilb.75.2024.01.11.22.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jan 2024 22:58:04 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS] fix invalid write in pop_cmd()
Date: Thu, 11 Jan 2024 23:57:29 -0700
Message-ID: <20240112065730.261392-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The memmove() in pop_cmd() reads and writes beyond the end of argv.

This is basically harmless in the current C program; the environment
variable list immediately follows argv so all this does is unnecessarily
copy the beginning of that list.

However, this will become problematic once we start calling C functions
like fs_cmds() from Rust code. Then argv will be a Vec<String> (as
*mut *mut i8) and the memory layout will be different--in particular,
I don't think we can assume that a Vec<String> will be NULL-terminated
like argv always is--, meaning the invalid write could lead to heap
corruption.

Also, it doesn't look like full_cmd ever gets used after calling
pop_cmd() so I'm removing it here since it looks unneeded to me.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 bcachefs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/bcachefs.c b/bcachefs.c
index 7b8d4d6..7ca79ad 100644
--- a/bcachefs.c
+++ b/bcachefs.c
@@ -104,16 +104,14 @@ static void usage(void)
 	     "  version                  Display the version of the invoked bcachefs tool\n");
 }
 
-static char *full_cmd;
-
 static char *pop_cmd(int *argc, char *argv[])
 {
 	char *cmd = argv[1];
 	if (!(*argc < 2))
-		memmove(&argv[1], &argv[2], *argc * sizeof(argv[0]));
+		memmove(&argv[1], &argv[2], (*argc - 2) * sizeof(argv[0]));
 	(*argc)--;
+	argv[*argc] = NULL;
 
-	full_cmd = mprintf("%s %s", full_cmd, cmd);
 	return cmd;
 }
 
@@ -190,7 +188,7 @@ int main(int argc, char *argv[])
 {
 	raid_init();
 
-	full_cmd = argv[0];
+	char *full_cmd = argv[0];
 
 	/* Are we being called via a symlink? */
 
-- 
2.43.0

