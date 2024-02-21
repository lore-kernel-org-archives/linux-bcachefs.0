Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4479123C9
	for <linux-bcachefs@vger.kernel.org>; Wed, 21 Feb 2024 03:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708485875; cv=none; b=U/vYLlJTzE4OLWSFQh7YvvPpYXjSZ6y6fe+TdLkm5WYLb46qnH3RbB6lAuuoVeU3iyFhZKvx51iEfViI27nNLm+odncBNSgSKtY3O7kUrCo09kCtgQXDWCGmnztKuQwpE7c0vWEb6EeGthpaBJpv8dNchWoxwD56z2pzCkOlrr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708485875; c=relaxed/simple;
	bh=jFFx1NDRGgAej5JvV3GSRPsl1UdGdIhXpP4EXSCQ+vs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pm8T30xXR0OuLGcwoX69Uc+9+UCnx8sl5bk9eAhRUh3QwYYwp/7+o+gUxzk6J1kVr4mU7vzapF6t/B3qoQchx3MFMKCMZLsqKpJKB8ylk4Kx0ur2ZWFBXmnWIKk+P4PBSqC81KgRcCjoZAXKua/ZhuXkePxERvxAu30QFgCCf7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=et6eIQEM; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="et6eIQEM"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7c40863de70so269901739f.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 20 Feb 2024 19:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708485873; x=1709090673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MvHhgaRCy8oS7E0GvvzX9LEpZrspepBjeadqK8G/8D0=;
        b=et6eIQEM4kZEgyXtbzHdAYPRteqCz1rfK7W7jTQ/w2n09WqzRjbrmycuXUv1Wz/ULA
         bjPQKr4HZA0GLjufjRvikzLVsVgazl5/T7EaqoDu+FsHOcwjDhaTwuBj/np5Mr2CFBON
         VLhmIFCmDTdZatyJBEhT3dsnAHloQGaeDuCOQftMM5ak947+DwCdlxlwvxiyHRMNj1Re
         Z3F3KkGtMumQSSR+1N7QdVeAo4OJZN+aSpLuju+2tAZjBBqlB4NyafpoINVmwen3/70q
         pzeCQX+X1lzHXnjTNYhN19aSX3pAH7YQLxADsJt9xqXfs4hrkkG2i5gyu9RRB49BG3AB
         /nXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708485873; x=1709090673;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MvHhgaRCy8oS7E0GvvzX9LEpZrspepBjeadqK8G/8D0=;
        b=r57ugGOiqEEIoQ0Oiuev2RyLsdN2gTKeSWb4OWbWAB4Tv/zszR1aLgk3wU7oOismyR
         ZKm+7gV085xZWXsilT+OCYt3+sZqLmfJBRe9pbexuBtUZcmKbTm4unjGsCtrPmVwFvys
         dN9RIxYnbbMYN7jVUPiFQBb0TQrKEnJAhRzAz+D83AeBpQgEnJxxQEjHkjP5XxaMCK5V
         iEdhbqAK3/oECWhrzrgyoCa2wC5GfCO3CKdNQJ+6uH8IQVzJ+gj6Ld5WcSLXLn8F2T2n
         r2kdZ7f9LtADZuZsZVnl3nvJzXzr4sN/wBrJVvq9C/O6/RtmhbJ8j3+LPgUZAG9h/3o0
         XaIw==
X-Forwarded-Encrypted: i=1; AJvYcCWH5rPkcAzHUmj7VqfII91ezbCw0t84Z2wwd52qEpBHYGyZbRbhjkXtHST0Q1K+TSaGwvnY5gr0PA2OVzXv+bRWnwvb2Pwm4hMNCm8gIA0=
X-Gm-Message-State: AOJu0YyuqrEJCvSAw1xmTrabHKntRZq7RIYAWOiE9sjKXt+q3DgKTgdW
	o/JYgCM7ip3e87R7DNVDuwvVnPHG5M2ypX05vUc3fB2M1y4ahDQP1PTLt3M+
X-Google-Smtp-Source: AGHT+IHVLuB/tE2Olr1kf7R69sURgkwwslC5Ttv6+KHbhoE95B7O12DwEDoRz/KRfyHD9zLl2hGWPQ==
X-Received: by 2002:a92:cd4e:0:b0:363:cbb8:53c7 with SMTP id v14-20020a92cd4e000000b00363cbb853c7mr17179202ilq.23.1708485873202;
        Tue, 20 Feb 2024 19:24:33 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id q15-20020a02a30f000000b0047447882b41sm35972jai.48.2024.02.20.19.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 19:24:32 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS] rust: use libc::Ioctl type for ioctl() request argument
Date: Tue, 20 Feb 2024 20:24:20 -0700
Message-ID: <20240221032420.73205-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The second argument to ioctl() can be defined as a different type by
different libc implementations, and can be a different size on different
architectures depending on what type it is defined as. For example,
glibc defines it as `unsigned long` which may have a different size on
32-bit vs. 64-bit architectures, and musl libc defines it as `int`.

The Rust libc crate exposes a type `libc::Ioctl` which is defined as the
appropriate integer type for the given libc implementation. Using this
type for the request argument to `libc::ioctl()` ensures code will
compile correctly regardless of architecture and libc implementation.

Also, because ioctl request numbers are defined to be 32 bits
(regardless of the fact that `unsigned long` might sometimes take 64
bits on some architectures), this patch changes the Rust representation
of the bcachefs ioctl numbers to u32 instead of u64.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 bch_bindgen/src/libbcachefs_wrapper.h | 4 ++--
 src/wrappers/handle.rs                | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/bch_bindgen/src/libbcachefs_wrapper.h b/bch_bindgen/src/libbcachefs_wrapper.h
index bc4658f..128592c 100644
--- a/bch_bindgen/src/libbcachefs_wrapper.h
+++ b/bch_bindgen/src/libbcachefs_wrapper.h
@@ -33,5 +33,5 @@ MARK_FIX_753(blk_mode_t, BLK_OPEN_READ);
 MARK_FIX_753(blk_mode_t, BLK_OPEN_WRITE);
 MARK_FIX_753(blk_mode_t, BLK_OPEN_EXCL);
 
-MARK_FIX_753(__u64, BCH_IOCTL_SUBVOLUME_CREATE);
-MARK_FIX_753(__u64, BCH_IOCTL_SUBVOLUME_DESTROY);
+MARK_FIX_753(__u32, BCH_IOCTL_SUBVOLUME_CREATE);
+MARK_FIX_753(__u32, BCH_IOCTL_SUBVOLUME_DESTROY);
diff --git a/src/wrappers/handle.rs b/src/wrappers/handle.rs
index 48148a8..60bdedb 100644
--- a/src/wrappers/handle.rs
+++ b/src/wrappers/handle.rs
@@ -22,7 +22,7 @@ impl BcachefsHandle {
 
 /// I/O control commands that can be sent to a bcachefs filesystem
 /// Those are non-exhaustive 
-#[repr(u64)]
+#[repr(u32)]
 #[non_exhaustive]
 pub enum BcachefsIoctl {
     SubvolumeCreate = BCH_IOCTL_SUBVOLUME_CREATE,
@@ -47,7 +47,7 @@ impl BcachefsHandle {
     /// Type-safe [`libc::ioctl`] for bcachefs filesystems
     pub fn ioctl(&self, request: BcachefsIoctl, payload: &BcachefsIoctlPayload) -> Result<(), Errno> {
         let payload_ptr: *const libc::c_void = payload.into();
-        let ret = unsafe { libc::ioctl(self.inner.ioctl_fd, request as u64, payload_ptr) };
+        let ret = unsafe { libc::ioctl(self.inner.ioctl_fd, request as libc::Ioctl, payload_ptr) };
 
         if ret == -1 {
             Err(errno::errno())
-- 
2.43.0

