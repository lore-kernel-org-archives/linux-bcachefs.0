Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF48677F1B;
	Wed,  7 Aug 2024 07:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723014613; cv=none; b=hnuErlChgAEAQ6tWzmvlYHcwIeC3Y/UkxSA0w2bQBT9DUsnxsEdHpHcFZABlaKh8Wai6ej5iJsrpJVQnGedJC8dihGhv0k/sCRTV5X17NoEkebRf6LZ9qdddkg7fLlxAAhA7haxm7Fv/0ArW9WO83D7FvolkDfvexZQi9t0N6QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723014613; c=relaxed/simple;
	bh=uP10GTJglQlvhNVyXNpACB8CNWxdLYPkr2TD5w4Ht80=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u/xzaMiBt0bfnYdE1Izcx5vp/VKV/HN0eE2B3pg0zQuhsrKumtsfJY5yvfUk2/k603dvIe7GQQcNWbCfZP/nZYQpbc7cJK/ayRwn3dngTY7ejWls9BhIcV7s76ijv515MTxfbFELGVxidgJt/R8r2alCUjMfllblGo8NL/A/KRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S4lf/8R4; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S4lf/8R4"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7104f93a20eso1150932b3a.1;
        Wed, 07 Aug 2024 00:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723014611; x=1723619411; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4RWP4CLRPK9GI7azts0XFQC+DKEv/lhB1h+1p4SNw0M=;
        b=S4lf/8R4LcyMwRUYM+NyKPJ8XipZR7+vdBwb7Dr++oZ9ygthA+tlWyEB/8J8kBGTol
         A3VwxoOSYHJuy7HtQSDgPSGc51/OQNiWExlsL5fUd7KOydg14WGgiuH6obrOtt4mwT4h
         C9TrvAXohzaO1f8LXyciUIy/EWwvcR49kxtRN3qrGDqeGCGJOtWN6S4gbXrx3AJ2KU5C
         NVSU2gJpyGuM5oAiSvPOBayhO9YT9ZIHXC44chWI8YPxdG9x2//DwyTQr+nkQeLvhGia
         mpkhmc7gigHBcSi3canuDgmvMAjXOCipXBxoUMXhKI1KFtk9VvKW+AOoMfmEw/AVDkj7
         cPhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723014611; x=1723619411;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4RWP4CLRPK9GI7azts0XFQC+DKEv/lhB1h+1p4SNw0M=;
        b=GXV+grJhs0DqtGl+lbcN9qBb6xec96fE/mpsYQ1QS5WqPX8Ejkz37OfT1ek+AG9SO8
         A2RmVOoEHAGRFhaGvZVc/hnQicrJEUMDinaJnv3DKx1oH/UwODVPIGESGy0JSbA1TyFZ
         FFq1u5zRBpZdf8Xy9LJuAwLv6sw3NzRxRAzCQnXzPpWO3bYAuTwDcY5JwxgP2VjB3bh3
         OjYkrEcp67CxDN9nSY6sDfmSEN4PTwudlDqZklTLUO/olDnvT4p9Z/55/BjTw5O/IkBR
         2judcjcamegHIcR7GvEobm0MrOuh8entqLAT/QZzOHbdLqk1yNM2ZQnyT6o30ss8xHJP
         1pJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyFazCi0L8Mv2G9W0PDsDmKexzRiBIPWYZPTvq60ViDGDp7d1qA1zFNKsVgxS0ij6fVU3Bm+SyVEWaP1WfnQMyxU+kK5jeHQOocmp1nqSEIAPttRatqKtX2FS9v8HsoEPRFRjDtfzEtxe53sZZj0+AAUP27CNyYos/GCcNrM057ldxliARWB8=
X-Gm-Message-State: AOJu0YwBbWBrlFYfOAR88BVItSVFMwpRnqr1pi1HdRESVyZWnuuyK02R
	cPjGaqw4pIAsKQ4DOrTVCs0wUQn3EJn9bEYItzSLeOuaso+edojI
X-Google-Smtp-Source: AGHT+IH9pHfByg2pHXB3Rg7K3BmoD3blolfIFDELyDWPKa7h70VqBxYiV6mZqqsAtdKDLsfAMXyV3g==
X-Received: by 2002:a05:6a21:329a:b0:1c4:8650:d6db with SMTP id adf61e73a8af0-1c6996240a2mr19272356637.40.1723014610949;
        Wed, 07 Aug 2024 00:10:10 -0700 (PDT)
Received: from xiaxiShen-ThinkPad.. ([50.175.126.146])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7106ec41394sm7868749b3a.47.2024.08.07.00.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 00:10:10 -0700 (PDT)
From: Xiaxi Shen <shenxiaxi26@gmail.com>
To: kent.overstreet@linux.dev,
	corbet@lwn.net
Cc: skhan@linuxfoundation.org,
	javier.carrasco.cruz@gmail.com,
	shenxiaxi26@gmail.com,
	linux-bcachefs@vger.kernel.org (open list:BCACHEFS),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] Fix a spelling error in a doc of bcachefs
Date: Wed,  7 Aug 2024 00:10:05 -0700
Message-Id: <20240807071005.16329-1-shenxiaxi26@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Xiaxi Shen <shenxiaxi26@gmail.com>
---
 Documentation/filesystems/bcachefs/CodingStyle.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/bcachefs/CodingStyle.rst b/Documentation/filesystems/bcachefs/CodingStyle.rst
index 0c45829a4899..01de555e21d8 100644
--- a/Documentation/filesystems/bcachefs/CodingStyle.rst
+++ b/Documentation/filesystems/bcachefs/CodingStyle.rst
@@ -175,7 +175,7 @@ errors in our thinking by running our code and seeing what happens. If your
 time is being wasted because your tools are bad or too slow - don't accept it,
 fix it.
 
-Put effort into your documentation, commmit messages, and code comments - but
+Put effort into your documentation, commit messages, and code comments - but
 don't go overboard. A good commit message is wonderful - but if the information
 was important enough to go in a commit message, ask yourself if it would be
 even better as a code comment.
-- 
2.34.1

