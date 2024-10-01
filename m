Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556331BDABB
	for <linux-bcachefs@vger.kernel.org>; Tue,  1 Oct 2024 07:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727769417; cv=none; b=nh/yrzx6DmAbwBxGKyTidOmPILtahaBzg0FXMiDqKrNsRRq8FrEA4UwiXec1D+0KbokmXX47Wc3iOnhEU1qMr+0rrJB8izVIMHoYsDdmxqW2duDwCIIQpzzvsy9z7xinK6CLoafRfYwsjUTDqLqqZaI6Unea9o9M39sdQVkynVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727769417; c=relaxed/simple;
	bh=hmIbj7+XZLgOhFGw4RWPf9oczxfFz+dePLL7WvINzf0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IlzYinytM7AYCIVm73L4lkbydQtPGZ8yzfvWx8ymibH0+XsO7DZBQdOyVbu6GOYaO8hL8jZQIt9qcBxlcZ+j37czm/WLm6ELHl7KflJj+PauMoyLpxEXyIFount4ImD7Towc0pcAV05olc0G/VynkL/fTQebQJ1p81UxkteSF1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OUnzRH9p; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OUnzRH9p"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a7a843bef98so753102666b.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 01 Oct 2024 00:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727769413; x=1728374213; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dwcb6VuEvI+0FzELUSegKsWZkuaxWi+9GQQVFOMXlTc=;
        b=OUnzRH9pWd+8K/S0kfzqN/Wqo+/gaBwyFHJJBfZOoez6A0Y+E6ifwWSRKZA09N7pbQ
         cAspXxlFM5yQjzL1W2dFoIwNT6hMYQazdZB9H57wnHIwh/lyl4iSvWqcu5JVUZ7IdOM6
         scL3DCrZgOIFzfr15xK5EB3U3JnWA5zf+Mq7oKrTCMMeoZ4sWrqRINUoskGQdhcY9Uk/
         c3KkViNO13/nPmUSOzUDClzlT7zllFy0aEng8G0K2ZpVrBgtyUC+jVtrwYVOYjWNoSUO
         Pe5aea+kehYrsQ6OeZkBA7G+ZV3P3O7wLmprsEv+qOCGuzy2mi9iwWKSkT0fMkwFNjo2
         fX8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727769413; x=1728374213;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dwcb6VuEvI+0FzELUSegKsWZkuaxWi+9GQQVFOMXlTc=;
        b=KEoporFpX7Fja59K7iKIBgB++Ad0hPWeCQW30TlbXg/d+YVEuD4kvvuvmutBzCzjo6
         CscuU+Iza/ETVprSAKnm4N1KIjpMAGRcSy86r9yVpbSY0ZTSIWLjvmysBYMt5OZZmdKg
         HrqszsFajzULfAeu/MOyKcVF8/UsMNzLRVMrSurWbaKDHC1SaWpdl4iL1c6D6gbfFick
         x9ppKD3LrstnXKtUyL/9kI0iM5eyQxYpf/ht0oihhf9MGbJk4+vB5EzozOZu3Xs00Sle
         5z6vC8A7j7laUJQTUhAYT9wMn2q2nmxGzj7aAesCEjJuQx4VV+Wy3IaGQw5kt59sCwfN
         w29w==
X-Gm-Message-State: AOJu0Yz+IIwvwbXotMlCe/kD70t9vLsZ3dn2O2qWaXebrXuRo+Dpu/yO
	6Cz5CF7cPaFy5AIU6jJUTAC52ZdO+UPDLtSbNuoFxWheMLmFEuR7PMUcBYYgQL0=
X-Google-Smtp-Source: AGHT+IEJO48ZE282a9evyTP+1urVkdk/EVu0RYwlX0+WBPWlBPqMHrl7ErtBC39W+YorMTsptuQkjQ==
X-Received: by 2002:a17:906:794f:b0:a80:f840:9004 with SMTP id a640c23a62f3a-a93c48eea6emr1581772666b.12.1727769413543;
        Tue, 01 Oct 2024 00:56:53 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c27c5b45sm658859966b.49.2024.10.01.00.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2024 00:56:50 -0700 (PDT)
Date: Tue, 1 Oct 2024 10:56:45 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: dirent_points_to_inode() now warns on mismatch
Message-ID: <9a704bd8-d227-4663-b160-7265bc31e507@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Kent Overstreet,

Commit a6508079b1b6 ("bcachefs: dirent_points_to_inode() now warns on
mismatch") from Sep 23, 2024 (linux-next), leads to the following
Smatch static checker warning:

	fs/bcachefs/fsck.c:38 dirent_points_to_inode_nowarn()
	warn: signedness bug returning '(-2157)'

fs/bcachefs/fsck.c
    31 static bool dirent_points_to_inode_nowarn(struct bkey_s_c_dirent d,
              ^^^^
This is bool

    32                                    struct bch_inode_unpacked *inode)
    33 {
    34         if (d.v->d_type == DT_SUBVOL
    35             ? le32_to_cpu(d.v->d_child_subvol)        == inode->bi_subvol
    36             : le64_to_cpu(d.v->d_inum)                == inode->bi_inum)
    37                 return 0;
--> 38         return -BCH_ERR_ENOENT_dirent_doesnt_match_inode;
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    39 }

regards,
dan carpenter
