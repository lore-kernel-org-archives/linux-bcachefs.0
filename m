Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC202AF09
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 22:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715638984; cv=none; b=X2b/EVHcGv3LHeyN7zVvJGk/eyNI8X2DDHNC0slSOqEjfJOXoxvJYOxTtC7nQOfTXzErN+GZy7WImrd9icp7V0/tHyO2UhmpKrdxkqpb6LiyI1mAe+/wznjLiAmUqhrpNYgOjlHIHLUeEghObxezqBEPs41udS9QhVbpbfqZ+Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715638984; c=relaxed/simple;
	bh=qihDpSXYkZPGyrZuXm5zFFpm3GMwlkg4SQfnZvEgJ+s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jRb8r3OFlHY0ExqJgJZ7yIEQoGJwcM8IOnEQQkilG4YKFHQK0V2/ruP7+FPkiezphCqJzw4gqRXulfsCjHQVUztkfpC1kTcTMXXKBzL1Zm5DeOGJEpZx6wl7Rlhtoqd/+PWl4JHTc9Qkcs6XvpIfpzv2TxlUNIA/Hy7uJ2+hqMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gkaQb3iD; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gkaQb3iD"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6f0f87f9545so1423087a34.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 15:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715638982; x=1716243782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z8jbazrN0J/cVRJUTpOSaXJMeTQG/cumIFaP5LNnjEE=;
        b=gkaQb3iDDWicsTMuJfTRlIGSvDTpfh1UMIEJACDj1eg7RRsPMtuluzpPlUNZD0tY0W
         /UFF1QYv+36OBHW1cvkhHEFC39vtHgnibG4IPPingGKKsQai+xrIrofKQlOZgNtXWGuf
         NVSwOYhNUWu5p6rs05jYBM61V5s+aqvi9BXRPgRhT/g8rhbzvkXatXkO5KNqykgZKTFP
         3bJSmGGoIF+jV6EIN/wjNO4/zfy3mKgFjYzq6qL8q87TVukcd3asDdNeAxvMXG5BJhWY
         B7WN1+TaVw6u20fYot1/NW60WsR9ZtICpn4UkLzA9WPVmd+DCrwpxaqFG1aiP9apGqae
         7J9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715638982; x=1716243782;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z8jbazrN0J/cVRJUTpOSaXJMeTQG/cumIFaP5LNnjEE=;
        b=iiGXxwXyPh8Ja10HFdtkAaT2CjZD4JdbaBWsQ57FyUb8q+YoAEEMv04Yap3Ijjy+uT
         ukZAHEjdyxlw7ZMYnfR67Rn9C/NUZlWGgKC0AZtuuVd6JlXRk+ZThM9kUaClS+90UfHD
         TGh5T4BBEUxBvL1JzdFNqxqMHg6f32kbOpCl/0Q5U6WRXciIK4WnsUqY23hqFt6uhTxS
         8FxCTInq4LTNu09y9MZDtT94Ce1cxwPxQIAYrsACx3VscX4vhlK0RpmZ+Em8Cd3K3XF9
         vABTHVY2rMvk712NGyubhxJOgLDfGw478ibtIDQroPM1Ywb46ZXUBltEQ2CTsKznIZad
         kz3A==
X-Forwarded-Encrypted: i=1; AJvYcCWiFCuzaH8sAoEgw1vHcpBvg8Vu3BbAeBogJJL1DOMmODGkjpXaQEdunl5A7KRALCx5dcHyX3J8RjX5c5qiYQJc/wDvsqopxyVg82xbXFE=
X-Gm-Message-State: AOJu0YwjQXQq+FGTFk/Zmska07hoGRd0p9xo3jAN/vXGgES1HsJmfFAS
	3W30XCyGaASCYTpZyUPgiKad9KUoqHt/f8Egbcn+AQUyTqPwNp4l
X-Google-Smtp-Source: AGHT+IFHHrZ6WlJDxCuGuQNloPm/mNQwLiKNTwhafl7b4zwBLHGuvw3u4UVi0FCnk8Sew0ZPGud1Aw==
X-Received: by 2002:a05:6830:81:b0:6f0:6e00:1bca with SMTP id 46e09a7af769-6f0e9133d6amr13124289a34.11.1715638981874;
        Mon, 13 May 2024 15:23:01 -0700 (PDT)
Received: from moria.mynetworksettings.com (pool-100-6-165-19.pitbpa.fios.verizon.net. [100.6.165.19])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792bf2a11e8sm494131685a.58.2024.05.13.15.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 May 2024 15:23:01 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	bfoster@redhat.com,
	linux-bcachefs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS 1/3] include debuginfo in bcachefs binary by default
Date: Mon, 13 May 2024 18:22:25 -0400
Message-ID: <20240513222227.3755093-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The debuginfo is used by the "bcachefs debug" and "bcachefs list_bkeys"
commands.

Rust 1.77 [1] changed Cargo's release profile to strip debuginfo by default,
but we always want it included.

[1] https://github.com/rust-lang/cargo/pull/13257

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 Cargo.toml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Cargo.toml b/Cargo.toml
index 853123ee..17650563 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -23,3 +23,6 @@ either = "1.5"
 rpassword = "7"
 bch_bindgen = { path = "bch_bindgen" }
 byteorder = "1.3"
+
+[profile.release]
+strip = "none"
-- 
2.43.0

