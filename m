Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0831EAF9
	for <linux-bcachefs@vger.kernel.org>; Fri,  3 Oct 2025 10:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759488164; cv=none; b=POqlJgYmjGl6XVAYuto/cmZVTIjGuUocYN+SIfn2277FhbfzeMEL2Ftoyt5tiaoWeUQmD0kwHJDdZVVTe12MWTZ5oDtaSUl0TZvnzXUzgPCZbamOk0VvmeRsLYJpSy3V2SZrOfIkhxGbZDcxlRWXE910dq/nuUimhkIuHv59RJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759488164; c=relaxed/simple;
	bh=9vU+gFI0ZcyKqcO+YMRT/VscZFLSUsL3371XMYETUk0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZXnwIK87n0aY6WkP+VpXEaWogKTj3kIiJAMYoFlZ7LVWkvkw99gSu2jzUmWQHArLi2kDVMCVMg7YfFYfb5kErgvIXX2UTQArslFRpvluxMKfeSTcBn7XPAko5AJp/Lz001KlkwBDwgr5TX/lK70J+IrKarIXcLGZLaal2kCi/ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O6c6VKvz; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6c6VKvz"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-780fc3b181aso1256497b3a.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 03 Oct 2025 03:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759488162; x=1760092962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RwmUO/u5hGRNT82BOFXNI9lW6Vs7x/u9zNeaSGc04AY=;
        b=O6c6VKvzfCQh7cfr7CZ6m6P6bUSu1P0RQPKu1nsfLTQMXmjiKmuOVwgWsdkSgeobhk
         uz1Cqq/obYuhf8M26oP1lhM3L81/u3iMe77qaLE1HKfxfs/DSBUeZjLiKlYH1jPSZrXJ
         mdBbKNYLbBZSCIX1tAw8rii/VKbrI9CRCneCvWMEChNIvzzdHRkMDf7EjjpDnmSnN95r
         Q49+T/qOdd9v85DYX1lNgxgkpF5ongUzfxN2F5hVoRhi2UwdBBgvV3HiCZTLELqNrxnq
         CuuxUEHaHL5O7z8q02XNiButD2p+lTX3/2dBDIQVOEnluJrwy3HnR6AlJfGXLeFELqY9
         Lk/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759488162; x=1760092962;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RwmUO/u5hGRNT82BOFXNI9lW6Vs7x/u9zNeaSGc04AY=;
        b=oHGF0u09q6LI25TDYhB/WB/e6rpD5gT04i9TN1LOiX45ZH2sLn8t9Yar8nZM0FVm7Q
         9t/C4umjHHwHBAQu8ThxT3vfIe9ro5dV/Rm9fPjka/Is+8lAYqAD4z6cS8ThHak/tGQL
         qD6Sej/VOrG9OasQuHsqXzjWz10/W04xju2fveyiXlhhQhS+PktRAGIcRcdHsCRZiZfX
         mgPcS65WFLui15R+RqeuJ8YaiGv4mtK3uKu8kVlrIlgs64Rs75Iskntpvth/XTOfBK6S
         ZetoXsz2CjhH0+bgCoW7moILQ7pZgx9UxBxeCQdf7Z/JcH9popcIIiHhoFF3wJubBcYa
         GdYg==
X-Gm-Message-State: AOJu0Yyz/+HyD8D2u5c1pxWa9S1Alu49MXSFtN+H3v555Gazdew0sCde
	gdErvuwMdWdEMI/8hxDKBbfjIFKBhqfMKqqQKJ3lpEnQsDPw2qSgmxu+NA2pRRRV
X-Gm-Gg: ASbGncv2hTc/TGi/yNKbFxMT+kyeI3NoFVYFjbQHYlr5bQiD8ccoo/BkNbF6+qNAXEJ
	5LythdRoOca1VrC7Vw+c+jgDazunZxPLIBEFyHtv2EAkgKqH2Uk/RCfTWcSDsbxTYhjKpi4cA7M
	CuggDb7GyOc7x/E5b8nGWjpciWqxX1/+rvqsAwrgRFURtGIi7egD0aTlGBkL52TDJY1JnW5mEq+
	WT0cNwIPkmEjqC0/yrLF92Z1wlbiJ8V4lQdlNDSAnaCAZb91XA2o8fOxd5Iq/dRoT1rgCt/WH+b
	ARKTRQNPVbglZPTKluoFXrBIsaJ6zd7FiE9Nh01QDEdjelwluYpnZBrRcnPkKd8zTGGusj//BtQ
	YQgOJsyWH7zd1wFoUh38M95XM5e+yYTsmlx1EoSO+BA==
X-Google-Smtp-Source: AGHT+IE/f5YO1cc2K4MYEijAihcWQxYnubDOwkMaPypNymrFgD46j3UZ6qxdAFfX7TopaOts0/LFLQ==
X-Received: by 2002:a05:6a20:9187:b0:2fd:5bf0:706c with SMTP id adf61e73a8af0-32b62118956mr3702026637.58.1759488161945;
        Fri, 03 Oct 2025 03:42:41 -0700 (PDT)
Received: from fedora ([119.161.98.68])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6099f599a2sm4270088a12.36.2025.10.03.03.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 03:42:41 -0700 (PDT)
From: Nirbhay Sharma <nirbhay.lkd@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Nirbhay Sharma <nirbhay.lkd@gmail.com>
Subject: bcachefs: question about fixing use-after-free in bch2_extent_ptr_to_text
Date: Fri,  3 Oct 2025 16:12:14 +0530
Message-ID: <20251003104213.369614-2-nirbhay.lkd@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Kent,

I'm investigating syzbot report 564efbe31172fe908429 and have 
successfully reproduced the crash with the C reproducer.

Link: https://syzkaller.appspot.com/bug?extid=564efbe31172fe908429

The issue: bch2_extent_ptr_to_text() crashes when called on a corrupted
extent pointer (bucket 27 < first_bucket 1024). The validation already
detected this:
  "invalid bkey: pointer before first bucket (27 < 1024), deleting"

But bch2_extent_ptr_to_text() is still called afterward (for debug 
output) and crashes in dev_ptr_stale_rcu() when it tries to access 
bucket metadata at an invalid offset.

Looking at the code in fs/bcachefs/extents.c:1247, the function calls
dev_ptr_stale_rcu() without checking if the bucket number is valid.

Should I add bounds checking like this:

  if (b < ca->mi.first_bucket || b >= ca->mi.nbuckets) {
      prt_str(out, " invalid");
  } else {
      int stale = dev_ptr_stale_rcu(ca, ptr);
      ...
  }

Or is there a better approach? I want to make sure I'm fixing this
correctly since you reviewed my previous dirent patch.

Thanks,
Nirbhay Sharma
