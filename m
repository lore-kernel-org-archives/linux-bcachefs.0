Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4689238382
	for <linux-bcachefs@vger.kernel.org>; Tue,  9 Jul 2024 01:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720487549; cv=none; b=CcjuOiRNAXfZuPhXyEzKWbXyIg/pWPWd7OoXQc8TswgrBDzgzjVADfatwcAb3j46kCvHi6o9qODDtqXvZO7NCj6f7QfMdksofwiHvZ1qw3OWlSLx1Hdtu7l3Xb8XZ+LPh0uVg+fxbLjXLa+bUTf+dV/OeC8fwbGRDUUxA6B72+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720487549; c=relaxed/simple;
	bh=M/haVXt9kBWZPHRlKxuQqZvuBj87zF8ixybMgHC7E4g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KY+hYkoa+O0Mx7hjFcdkHq8AgIZ5ER6sAvjb78Ag5hEaxWZVFNHYy8bXupjNz8zliF5TmQ9OFuxARl9kWgRS+rPhWTenyvkRgmtpvJwSR/H/Zih0ZUQLkx6BESIQ7yzbZz/oZwkLxJ5THPPNlmfIILc8URsvk/xAQ3HCxszi1fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HMBQot+u; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HMBQot+u"
X-Envelope-To: kent.overstreet@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720487544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/WRsCkWo4c3DSYd+4rnVQGauuQ75xbcJ6EVIzRWnhf8=;
	b=HMBQot+uW12ycR0be1x+LA7NH1Xuewq3jNHRzRtVH5MoisdbjDktD882jU3Abf0RGnDWIk
	L62EgibZP3vRqv4l4YInaqGk0XzPKCy8MwP08H1CEwEgQzc3TKhOYabdKmpEDVEd78PR+c
	quyMYBGkHWMjWo54NkVcPj7gaI+py9k=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: youling.tang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Youling Tang <youling.tang@linux.dev>
Subject: [PATCH 2/2] bcachefs: Add support for FS_IOC_GETFSSYSFSPATH
Date: Tue,  9 Jul 2024 09:11:34 +0800
Message-Id: <20240709011134.79954-2-youling.tang@linux.dev>
In-Reply-To: <20240709011134.79954-1-youling.tang@linux.dev>
References: <20240709011134.79954-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Kent Overstreet <kent.overstreet@linux.dev>

[TEST]:
```
$ cat ioctl_getsysfspath.c 
 #include <stdio.h>
 #include <stdlib.h>
 #include <fcntl.h>
 #include <sys/ioctl.h>
 #include <linux/fs.h>
 #include <unistd.h>

 int main(int argc, char *argv[]) {
     int fd;
     struct fs_sysfs_path sysfs_path = {};

     if (argc != 2) {
         fprintf(stderr, "Usage: %s <path_to_file_or_directory>\n", argv[0]);
         exit(EXIT_FAILURE);
     }

     fd = open(argv[1], O_RDONLY);
     if (fd == -1) {
         perror("open");
         exit(EXIT_FAILURE);
     }

     if (ioctl(fd, FS_IOC_GETFSSYSFSPATH, &sysfs_path) == -1) {
         perror("ioctl FS_IOC_GETFSSYSFSPATH");
         close(fd);
         exit(EXIT_FAILURE);
     }

     printf("FS_IOC_GETFSSYSFSPATH: %s\n", sysfs_path.name);
     close(fd);
     return 0;
 }

$ gcc ioctl_getsysfspath.c
$ sudo bcachefs format /dev/sda
$ sudo mount.bcachefs /dev/sda /mnt
$ sudo ./a.out /mnt
  FS_IOC_GETFSSYSFSPATH: bcachefs/c380b4ab-fbb6-41d2-b805-7a89cae9cadb
```

Original patch link:
[1]: https://lore.kernel.org/all/20240207025624.1019754-8-kent.overstreet@linux.dev/

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Youling Tang <youling.tang@linux.dev>
---
 fs/bcachefs/fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 011ee5075a52..8699770398d1 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1978,6 +1978,7 @@ static int bch2_fs_get_tree(struct fs_context *fc)
 	sb->s_time_min		= div_s64(S64_MIN, c->sb.time_units_per_sec) + 1;
 	sb->s_time_max		= div_s64(S64_MAX, c->sb.time_units_per_sec);
 	super_set_uuid(sb, c->sb.user_uuid.b, sizeof(c->sb.user_uuid));
+	super_set_sysfs_name_uuid(sb);
 	sb->s_shrink->seeks	= 0;
 	c->vfs_sb		= sb;
 	strscpy(sb->s_id, c->name, sizeof(sb->s_id));
-- 
2.34.1

