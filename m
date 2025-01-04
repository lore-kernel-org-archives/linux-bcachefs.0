Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317784A3E
	for <linux-bcachefs@vger.kernel.org>; Sat,  4 Jan 2025 04:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735963630; cv=none; b=RqQ5SDHhKYQVs+d6CBdsmpl14PpE+KbnAep8zjt6SjHkYYQdi00f81mFmQwKwt4DpQ+U+2LSXDhTiP38ux8whQ9RJlCQwH1IFqADQLoKDcI+LO9+gP14E6q8qjlbaypluAO96R89zsubUhXuPi34OXFP7QL8PMrdY5TrTawNl8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735963630; c=relaxed/simple;
	bh=FjyU+S++2skbXRWJnLd6KF/PiGkyBqzBanmL2EJVmoc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GNGftfmX69M/ou9O6jGzQtNGd6UHZluhN0l3oLYnwroVgX542GhMZ92hE8D2c1kXSguhajbtBQ9kbpzIYyYL2ifs+eUe3yEpKJoBqmzFysvw9K1MU+iWuxef3Lq0MTzed1CVlXyWpR0hM3WBOK6FnlbIntLyR1uWIPrk+/NWc+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AHnXjLi7; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AHnXjLi7"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-844e9b83aaaso1106830339f.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 03 Jan 2025 20:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735963628; x=1736568428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=FjyU+S++2skbXRWJnLd6KF/PiGkyBqzBanmL2EJVmoc=;
        b=AHnXjLi7s8RSOzjTLGDXDbIZ61UN2uwDS4u1h9j1vNzGbXN58UQVT9RHElrt54JCy3
         BVxbl3QvP+ZwKNBtczwgY92CTzDnTSb3gQrvgZe86EcnKIBO3Fvmd58da7spohKW2QdV
         tp4cnaagtDF2Y9qTvRiVYbzatDGqxttW+YMLGDfdf0V6QEmVysuaVl7NDpi9rNDDC9U5
         TOayLvN3ky1e2tdeTcqaAt4F5ttLqICLthttRwd+GNgl/YRRgw5v92E5x2Jq1r6uhND3
         PO2VkE405MpZHlCIQ+0WNrUKsOZzLyItOT3kOdj+pxHdABon6FdTxzaXazUuw7FSAUIT
         nVQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735963628; x=1736568428;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FjyU+S++2skbXRWJnLd6KF/PiGkyBqzBanmL2EJVmoc=;
        b=ks9uU5GVWEExojuhyyZpcSXDe+zbjGiquJt4syR3a+pJSBAE93E/OcTqWFZuHePObv
         4BIKRqOrtuscPl6JSQu1xXnzwOXIEvYMZ1DVoAuYwHFJvwC4N1HWEzcSvOfzOw7fhT3h
         NyCr8aSDRj/eAUvSN/ARB1YWqTdQtXIr392B36gSJLt4cYvWg21oEUrU3T2sl0+Nsjuv
         9tzEk38EYzOX/H2qHxAondErrcNfCSro9x2zZJHyz49rbo1Dpfb1LMBOg/ugNOiF9Pz2
         xIQVr4WORBcLnHAGu19bY0liQPWGv4AHXe3wiWVE8/YDV6gjXkf/e8D9i3wU3+tI4mYe
         AXIw==
X-Forwarded-Encrypted: i=1; AJvYcCWYCGz6fY0LAwPGv2ex52kzci1aqXYZHMUFhaNuG7gWr202dOdrcbZqwoJKmVh5DoU3nFxoFBLkSEPSdcmriw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzmZoy8XNv5pY6u82B79jn7mD1y+N0OlDSU7sFdGd/N2RtwxyIX
	I1snE0GdlDuOkyVO+6PJTuOOgb/qPoQ+nuvU1Sn5p3kF5QqpMcQ0zs4DpQ==
X-Gm-Gg: ASbGncsBFvuQNHhcM6mSmh005R/l1lvgmfXtrPqJaPUIfk8txq4MuU1F57TLVF9CmY9
	lvZEhVQmVZ6Dce6mA41m3ky7Qbp4PtigxW8AdybhhZBPCJcl/sJXi9NVnGNu952h77mYKxL1G0v
	BbrSf6XPbItchWPwNTkrnpMreCNV15BFNXFHjRjUE0JyHcntl5sRr1RpClYMTK5mjoFphcjbYGI
	1rKx4HUfTjdssUpetgiPtod+nmzsnM7wnzDGhzu0dsT6BqfD4aXL6bY+p7Dre5iR2n2G/isyahZ
	Ymg6
X-Google-Smtp-Source: AGHT+IGvvgRsJuVe6YsMYB3vhjIX/rM7m/Dg+eoE+ppzZj0H2NMyOGADY7N93jfHAFGmCerQaiOehw==
X-Received: by 2002:a05:6e02:1ca7:b0:3a7:1a65:2fbd with SMTP id e9e14a558f8ab-3c2d533ef0amr401515265ab.17.1735963628315;
        Fri, 03 Jan 2025 20:07:08 -0800 (PST)
Received: from arc.hsd1.nm.comcast.net ([2601:8c1:c100:2480:5fae:69c4:d149:aeba])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3c0de0545c8sm81407875ab.10.2025.01.03.20.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2025 20:07:07 -0800 (PST)
From: Brett Holman <bholman.devel@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: 
Date: Fri,  3 Jan 2025 21:05:37 -0700
Message-ID: <20250104040705.160266-1-bholman.devel@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Without this patch, cloning the bcachefs-tools repos fails when
running bcachefs ktest tests locally. This allows cloning to succeed
when interactively running ktest.

