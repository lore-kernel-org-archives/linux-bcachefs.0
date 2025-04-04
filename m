Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44DB12E7E;
	Fri,  4 Apr 2025 01:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743730108; cv=none; b=X+mq+XXQVi2BSc6Bio2WKOIhNeKtFsIBz+jXzbeo9RBMh3QMyIUH95EGsCsZb7yC4TBocIiOJyHgNzjD/GFlAnMsTLJFBLAJ8Hm7Kp03KGKa51Cy4UhrFgLvjMQdr/xH3szxJ6klebhy7ES+7cEUZLK81QSclt34Szj6C2HLNL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743730108; c=relaxed/simple;
	bh=5+Giy3MvQ8w3Ogn/b9n3+xZekKG1FsumBjZO5LtSWtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xe8GVqaFWuau3cY3/7Z4d3utafREbHC/67X8bxjTohZ9Qg3ZNS1oDo5quf/qyudqluY4dt7Br5TfpX8TabfTO6wX6q0QAJ5PiZVhbh/NXDSg654B3IhsplfL1WHZHgwsnhHowrMQnAxFmUC1S2FHwSTakC87ikfgmdj36jRAEgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OUufdWQ5; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OUufdWQ5"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7c53b9d66fdso196028585a.3;
        Thu, 03 Apr 2025 18:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743730105; x=1744334905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z5KehqjscaqmbWM/FF2IgUe0rMAoDoCjxIkxHlSDOuQ=;
        b=OUufdWQ5pMmoVvtEPUm/wBONWCbWAuZbbIlrKB5kTmd4wxobeRHIKeDa+puqX/2NL1
         8ysiBRGQUULrWpWuNitnlNeQJZLtGMU5EBD034vJ4BB5yOBx1QuK3UA6DwrOstXI9Zrz
         aEI3815uKJnXosCKSPan5TqOI9SgzETJUDWhQF7Jy+o/6uEwYtHiIEAmOUD2cAI8nGPV
         o0Tc5/3rX3l98ZV+OXS3m8UOfsUeFt9BW0duM2pYXRLN6P5GVj6JTk2UfLCKV0DhC/eN
         QmD/wNBC4/YlFzS5mj7In+l94Zs3TqoEvFeH3Bh/w5Z6KqWyK6Bb/VdRgb8b2Vl/7Z46
         +cNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743730105; x=1744334905;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z5KehqjscaqmbWM/FF2IgUe0rMAoDoCjxIkxHlSDOuQ=;
        b=kCiXclKPzsGrnx7CJl1Zhfco/u0VUT50/c13OyKqLzCCn/S3rytlSJRyzF64c4q1qj
         uzGC5k9R7woAvbnMoK2Lzo98OjiF7OY3AfDk+rbpoNWVkNpi0SWDacpxTbWhSQ30GxWD
         hWNVdVrlQXv/CNczWwclDQWSNW5T7S5vFxT/O0D3fbzMBdbK8jjuBDZ08A/DZ/m+e/ax
         uZzb/mel2yWPleDsg0SD7kmchYoK8bpA7FttUrsVqgjLtejjAFHQe3Tnyo8MLP1mJK5Y
         apSqxaRnnpKr2Gr2+xNKiK6l2Nmn//p2QZw9yF4x6pzy/rpz8pvnJ6qfOP0D090bW2LT
         EVFg==
X-Forwarded-Encrypted: i=1; AJvYcCWLxbqOGTTamSoJNjrBr8y6jETrm/PxftgcdZjRU5rwXpiCAhu5xquLAkP9rtlbkohZTAxoQC+IeNt5m83U@vger.kernel.org, AJvYcCXYJLqkOBAmdPS9AG1bBsarlzcPSwh7vT3RFiggdf2ES359NslWKTIuex5OfnDF+Z/sr6UdnYUqXdkTF+Oi3A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv6NkLJlJib13Tn8087Y0tWxD83t3niuPHuZ1oATmn+CkP/1FJ
	sWJn93owxojrX9q29qcjFYw4lLxP0WhJTYImPPDqhOWyYCaBzSZR
X-Gm-Gg: ASbGncs0weDajeEN2WW9AKGKzUCFNlXVvzsE5LJoUKUZz4gQQxmtKLHZ5qWE9rya19g
	G+I70BgLElvf7DIWlDChuuw0uNqqIuX8dSPkik0v2gHMaRRUDJTL396HD8O6Fk4NHRAOf5vzPJ+
	iVV+2m5rM99rku5CDflLQdRs5AWfKkujXvtam96JeTZMB/1B2zSPOtIYZvVRG4SgEJLYvZgaUOD
	YfYmsXJK1My4c7SywZ+CuSAjRkusk1Uw+nBqus2J9L7OAFSXSHGujKh1ict5Xn+XIczNcE4hVkk
	Bp+fS4x8aKdGzhnajI+Nx5IhwoQMgtCHiNY/dwPQExXO33UOdzib9fGJXS+V9fu+aeTBq7yB9Ye
	sqfmVIFfVcvJ/Lb/014T6Zv0=
X-Google-Smtp-Source: AGHT+IH8rF5SgsSKXM0L1XV5g7fJdJDCNCo+lyIiVL3Oc0X593rI5DTIOdeNQczN1802u5TCgxIfvw==
X-Received: by 2002:a05:620a:4484:b0:7c3:ca9d:210b with SMTP id af79cd13be357-7c774d277b8mr183533385a.6.1743730105428;
        Thu, 03 Apr 2025 18:28:25 -0700 (PDT)
Received: from theriatric.mshome.net (c-73-123-232-110.hsd1.ma.comcast.net. [73.123.232.110])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c76ea58f95sm147401185a.80.2025.04.03.18.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 18:28:25 -0700 (PDT)
From: Gabriel Shahrouzi <gshahrouzi@gmail.com>
To: kent.overstreet@linux.dev
Cc: gshahrouzi@gmail.com,
	linux-bcachefs@vger.kernel.org,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev
Subject: [PATCH 0/3] This series addresses several minor issues found using sparse.
Date: Thu,  3 Apr 2025 21:28:19 -0400
Message-ID: <20250404012822.188485-1-gshahrouzi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first patch fixes a typo ('\%u') in a format specifier within a print
statement. The incorrect sequence was replaced as it didn't appear
to be the author's intent.

The second patch corrects the type for a function argument to __le64,
which fixes two related sparse warnings. Although the argument data
is already little-endian, using the specific __le64 type improves
consistency and makes the expected data format explicit.

The third patch ensures cpu_to_le16() is used when preparing certain
on-disk data (directory entry lengths). This maintains correct byte
ordering for big-endian systems.

Gabriel Shahrouzi (3):
  bcachefs: Fix escape sequence in prt_printf
  bcachefs: Fix type for parameter in
    journal_advance_devs_to_next_bucket
  bcachefs: Use cpu_to_le16 for dirent lengths

 fs/bcachefs/data_update.c | 2 +-
 fs/bcachefs/dirent.c      | 4 ++--
 fs/bcachefs/journal_io.c  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.43.0

