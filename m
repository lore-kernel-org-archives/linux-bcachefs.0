Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BA8C8F3
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Feb 2024 02:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708051475; cv=none; b=lGf/Z+1vTj9Y3Fqdz5iqLFW92SBeXEuCkSucclUgG7xpZFQ019UVIxEOIkU3hGEH6XyCBi2mSIeC3Bd70MxuvqiEv6FYHXfMB0r3hRnTfmKvme8H59lzZFE6hYWXa2Z0ui/x+GD+HmmUcufbFcdSsPCm5yHTNIpZdzncIyshXts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708051475; c=relaxed/simple;
	bh=jP7dHSWBOxkYbqKL6MNmkjNp4CQCPMUJ9/U3dR91HOI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mSR2delbV9O1x9lSNweU6to5upmWQ2o6QTjiBA1v+Fc7P1B0d9fSE+Bfd60aZh0mciwJQ/fCo/z28KkC61z4Ap0ULiBC6Uz6vee9nQfp0E9pmg6BX2FkGCWh0HfYnNWxZmCE7/YngBa7uUBxDUfeljAKCiINUhUIYXE5iNInw8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gnAoqKQ0; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gnAoqKQ0"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7bc332d49f6so74211739f.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 15 Feb 2024 18:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708051472; x=1708656272; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o4kdCxwkv8Az/FsoG3lVZzK4X1hQHRS0vrTji/+wdo0=;
        b=gnAoqKQ0CKvRG/cuc9Lsw/St7B+2Q/G6W4/Kiul4mpgbQv1KrGrgpNwV8fXoRTuHA7
         fL7hD7ZlwCvXDm0vXh5RYfTeHyC9y0QGnCMtukyiYlwq8n+wwZt5vlnWu+cWR31HkHI2
         R976UKkHyQUTrZD6ghMIHbJlzjtbYuoGqbqVrjDkgDxrqVtFiUR+kJZmo/8APk+tPL0r
         RT1RlVk0ejtRXwk0PJV5zwORvKVD+F4r9b6UtdR962m33zjMq1cy5wonFBBwsmg5YiJ1
         SC3rRNesq/OAmchWOCvvDlWNF2kz1J4Ujwv3b0xiJwKRMNw7icSJDMRs9Vo+P0TjhZlJ
         oYcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708051472; x=1708656272;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o4kdCxwkv8Az/FsoG3lVZzK4X1hQHRS0vrTji/+wdo0=;
        b=PUiEqWHdKeQaAv7GPvYLQi8J+oxv5tI0tveiqBTT3eovjsSpnMUjkDBOEdgnUvYbfm
         qySyWKzphjbT9lhYLZVfVJzFVo5uJ87RJzXEYrZxFKR5HSAJkmbtUEnHGdXg13J8W4JU
         Jlk4071BpJFXJN15I2tt0g0zeYwJrIZZ2qZk48gekVN936mlaYsAM1I7RGTTOhImNx5x
         sg73vkzckwarS+SejRahsR8SEyfpiEHAOnx0uoGC3H7CtFyrG+MJQDSJwPdRh9Wg+HeG
         vgVdfPyrKoA6A5sbg9FNGvvaLxJtwtHS+dO/OjQlNHZ7N5FPE7YFt/SspKrAu30oJyeV
         Dg6w==
X-Forwarded-Encrypted: i=1; AJvYcCULi1stN1NsqPSle2Ol/V1rWhoORb+b+fPA4lNWSpmqRh5cLUfhazw9F/ojyP53xIQLcxnmNxwwR0mhKWwJVkBmuxkTcm12ONbgHC+XMkE=
X-Gm-Message-State: AOJu0YzPp+gWpx9bxScCDQ4trglhFpCUwh9ZcYVZ52kiRhNQWkPiQOVA
	sRBhtbeKA71KO+K9ezEVDdPa52NQM/nDGH6SJEd0ZVrILDOBIkyqAkiP0GD72WI=
X-Google-Smtp-Source: AGHT+IH44vd11swkA+q24q7rTz9UckgxM12oBiVvCRm4NQTStAJz41eDf1QlQk9WsMt+/KvIPZElCA==
X-Received: by 2002:a6b:690e:0:b0:7c7:6f8:c646 with SMTP id e14-20020a6b690e000000b007c706f8c646mr1142199ioc.1.1708051472467;
        Thu, 15 Feb 2024 18:44:32 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id n8-20020a02a908000000b00472c7130ccesm649151jam.143.2024.02.15.18.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 18:44:31 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH v2] bcachefs: omit alignment attribute on big endian struct bkey
Date: Thu, 15 Feb 2024 19:44:21 -0700
Message-ID: <20240216024421.143152-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is needed for building Rust bindings on big endian architectures
like s390x. Currently this is only done in userspace, but it might
happen in-kernel in the future. When creating a Rust binding for struct
bkey, the "packed" attribute is needed to get a type with the correct
member offsets in the big endian case. However, rustc does not allow
types to have both a "packed" and "align" attribute. Thus, in order to
get a Rust type compatible with the C type, we must omit the "aligned"
attribute in C.

This does not affect the struct's size or member offsets, only its
toplevel alignment, which should be an acceptable impact.

The little endian version can have the "align" attribute because the
"packed" attr is redundant, and rust-bindgen will omit the "packed" attr
when an "align" attr is present and it can do so without changing a
type's layout

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
v2: add comment explaining why this is needed

 fs/bcachefs/bcachefs_format.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 1bb24aa73528..00060bc6128f 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -222,7 +222,17 @@ struct bkey {
 
 	__u8		pad[1];
 #endif
-} __packed __aligned(8);
+} __packed
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+/*
+ * The big-endian version of bkey can't be compiled by rustc with the "aligned"
+ * attr since it doesn't allow types to have both "packed" and "aligned" attrs.
+ * So for Rust compatibility, don't include this. It can be included in the LE
+ * version because the "packed" attr is redundant in that case.
+ */
+__aligned(8)
+#endif
+;
 
 struct bkey_packed {
 	__u64		_data[0];
-- 
2.43.0

