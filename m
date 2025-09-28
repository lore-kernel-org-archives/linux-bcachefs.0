Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BC334BA32
	for <linux-bcachefs@vger.kernel.org>; Sun, 28 Sep 2025 14:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759069667; cv=none; b=or2u1EkltxD4BhwNt7qeX52oVgUdDmaWMgf1khbs8pmF8tQp1Y1gxXrkMNGJ5WefHwuW33TieYge5nXFf/C8qYotOJ6Q60iJq0NCQm3XlFTQ6q27+3pqXVKzd6XRSR4PUOVodZDfTZrIILQozTCPDRHW2Gpj4BweMLXeszbm8L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759069667; c=relaxed/simple;
	bh=io9qNxY9X+PrVNEnkuA8Bot4yicEq+SMammTuRE5YNk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=A1gxO9jPMIZymBZJjkr8MR6IboyIdOpEegph0CbhvNtjovjiqzOqRiytugS/ORfX/XC/dXIgtYszJRgWi6/NvJl9wTM7po6M1FxZOzmu1R/qtJ14SuLhb5IB4YhZjQlBcUrOkmPeqLcKtaC9yVz5DEc1D+GipX+s005dyCxs8vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CTwKJCsL; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CTwKJCsL"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b3c2db014easo139199866b.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 28 Sep 2025 07:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759069664; x=1759674464; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ck2Hxuy0PYQPBJhJ1vSBxAgOM4bwd3u4vuJgU5om98I=;
        b=CTwKJCsLuS7a5j9VHt6ydNhIjhCuj5wndvzhDkYe8IkhjFhf896X6/5PmQ1+3ALQ0q
         usM+8YinHDbl2AAdyhxQV5nWDjqgxzAQ6895IBQFmlGhgFochqf+xwf+JQU0AsSfGzGP
         83c1D0ofMWZ2hPt5cyDw5oP/3ygD6ymbLTsqniijYzP+M2Rr/unQpqMzy7r0KXqlMj+o
         cwnDX4WGXEue8waGjaqLqapDR7rU5LV/dmBo4Uvj9UbCyyfDo30IuzZrxbg1xO2PKiFy
         hIdD58Mnkvk03XcptE1Qce6aB6XJktsnrnlGX1cVmkn7jFWrXxltGQR54STNSwXwkFgd
         IkXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759069664; x=1759674464;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ck2Hxuy0PYQPBJhJ1vSBxAgOM4bwd3u4vuJgU5om98I=;
        b=ecwlZTI+v3aA/ltDMtiEsP0fsKSjBGq5MIDWd2FiF3Mrtpzb1Unx+vs8vUqlbRbQKk
         jQ/Mf/aTYReRawYsJWejaMsZZHYvBbPe4YxjprzNPIF4z+eoACfhpAcyLHosznAENppX
         gVlGAbuUjxm7aXwCoAqnxBF+6DPV9rq5OV1botoBXfbbR6YIwfrJkVKNVsjxDMjPQ7Qj
         TzYFDlikvG0HIM6oQLsc0v3edvfFghhvNzPAkIMpa+RsWDVmjcAowGTyIGz8rZHWv0Sp
         yquuYMMgPwu5Er2aoB4Of+bnUvhFHzO2IqBzmAahunKiKi1LVLLvny0Oa9qxQFM/XXCz
         JZjQ==
X-Gm-Message-State: AOJu0Yy7gOdpPk7+96wDDTcYZ4FXNFKypFq8U7fzGRvxareAF0I/ZYBS
	ZPogr4qb4qbpIEtmXn/ciTgz+Xiz8HTi0mH/iO6qkzmUyQZ9gw/4jvx08FjbLeIZ/cbNIFoKELB
	o41RxscI4E2ZrtvMIH6PZXqvJ/aS/okEgmkG6H5Q=
X-Gm-Gg: ASbGncv9nPAhBFHNV0ubmNvKWjRxdhRQ+gEdpMRpmxHa1gjvIb7KHcvX9F2jAVjA10q
	PGuLCFJJNZhA3tzmNDijjoh+gkKodC/1J1uz3+I7CdEETA6MfBLggp5PZv+0RqPn64dSiwUB6sv
	ncec4FNtlIHSZeFo46Okj4ebEPw2fWMYOKxFEPH92D++VGR3UMzMQHY0JdpsVEYHcPGyElxziaJ
	uz/1+8CA2JK9XF2iJM=
X-Google-Smtp-Source: AGHT+IFQrJxi1Do26rJyB0HjlnN9v7UXvBotviHynLY5Ek4OJJVpvMo0lQ0pB+NyanfzgkPrxoUZbdzZfJ+J6yin6tk=
X-Received: by 2002:a17:907:86a3:b0:b2f:2461:c59c with SMTP id
 a640c23a62f3a-b34ba450531mr1446076566b.37.1759069663640; Sun, 28 Sep 2025
 07:27:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Asan Emirsale <asantaraqtasli@gmail.com>
Date: Sun, 28 Sep 2025 21:27:32 +0700
X-Gm-Features: AS18NWD0Xv-eS3oILTUPbhEVPr9rdNeuK_7SRbDermaiyoTqgmxnZdzeY4aR2ZY
Message-ID: <CAAxMig01gB2tSGQ8iXf9JLvFB-izSe2EfJNZ=-nbLokro6NFpQ@mail.gmail.com>
Subject: bug with set-fs-option command
To: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello!
I encountered a bug defining new params for my recently created fs.

$ sudo bcachefs set-fs-option --foreground_target=home_ssd-adata /dev/sdd
bcachefs: unrecognized option '--foreground_target=home_ssd-adata'
Version upgrade required:
Doing compatible version upgrade from 1.28: inode_has_case_insensitive
to 1.31: btree_node_accounting
  running recovery passes: check_allocations
starting version 1.28: inode_has_case_insensitive
  with devices /dev/sda /dev/sdd
Using encoding defined by superblock: utf8-12.1.0

$ bcachefs version
1.31.5

The fs was created using the same bcachefs-tools version.

Best regards
Asan
