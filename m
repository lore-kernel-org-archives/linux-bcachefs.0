Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0C928853A
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Jul 2025 19:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752694746; cv=none; b=ip4qR0TvzeMb6AbbMMVu3rIkdLuWO5gsHhGcDICvATXUU9j/vac5/iZlgBeIabIWfu8OZU/O6GuxLqOhUs8Xrd7WW0rjCb3hYDHYO4OlOl4B1A6DcT/6qK7IsfwFhAsFo1N6E8WS7lg3F9qM7ycTNiusinhPxjq9/7kE+Hy+npQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752694746; c=relaxed/simple;
	bh=v7xHIohC2d5vaMXo9AQBfNlmEOoVL3sjV8jYKf2BLzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RdGgG4Bms3COPlPZqd4JQDPfzVrBfUC6yvkBT/i1lm2DPB/BTf5ebsi4yV/eqmLEFM0zERyx/HIF+hL9AgNqb+i4HM8zndFeXUKAsMFIZn+hhjvauOZYK+zFts1p531tTNqG8UF1SPcjOlrQRBB5vNzcG1wYs199QEgr5DsPU48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ok2L3b2N; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ok2L3b2N"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-2edec6c5511so152196fac.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 16 Jul 2025 12:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752694743; x=1753299543; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EBVM9VC/r9pVi1+OzMcadgOpo3iK69zsNIs5tHaYlFc=;
        b=ok2L3b2Nrmo3I09E4CxPSMVN6cwxoxUpoZJPTrCyydalzKng9H5FknfORb5Ciz3gx2
         ZNhn7gxLlYe9oNfyvSpYWU7uE2FP2Zw/Z839t3+a40dU/LXI/0JSdTCvzYWQ2l2MRrfA
         Rqfy75yPgDlV7Kgk/spup1/7ajzqHXTlOJzoK63FDFrUNm/GD/PgDGP4nEmdbt4Toogu
         /rcFV115BiArp3TDX78Rjm8XunLTHPm/c+/LaHFyX2Smcw2b3MbPbqpjkvCrNwevhTXc
         DrJ+R7wEuhWpBroKZE4RAMYb+LcI2hUlwFI5SW6ODc3P6uraY2H/6dRW6962ekxzUZl7
         MXQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752694743; x=1753299543;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EBVM9VC/r9pVi1+OzMcadgOpo3iK69zsNIs5tHaYlFc=;
        b=qO6abfJ1vZN9RbYgswp55zukl3+OtilXaq+38GHfw/qpCmtMRTLxes0SKx1QH3HGUr
         dJCvO8iviY9eVh7MeqJAmkCvYl0leT19NdlWWB7TUaG0fXb18DUg3lwszxWmjPkYMcUl
         RqatDfSdCQHjb2fwfSgh3tc5WKsUuSNgWrMDlCPmfUIJTOfUmeSfUDI0dgyBWsSo2uXU
         ZtkDB7VWkcV20aFt+jwDDQDEtQeu1Y+1GfQwKnI6igcbfnqTZavDuKDI/2B0IT2dY8ZD
         4DPN+K9rTwgpEts6C/8/OEucNcpWTkMq4Ks/R39B3pmanvaqXUoFL2ll7yB4NoTw+dem
         9T7A==
X-Gm-Message-State: AOJu0YxvAjZ6KUM8JqMlsEIXzBp5f12VvlaUzu6Rf3JRtdX2esEYhjvr
	dzA70BT8TVsBRsHxN/ueqDkaBhPxCEOvd6FHnR6A+eR6C6aLR/dWYoRXOYROxKvhk6ppgGWFnZW
	J2zhD
X-Gm-Gg: ASbGncvH25Mxe+VjoXyCFeUnW7Cibq5CMButAD0/g/uTC3yxC9d76rOZHK3zWIU1eS+
	Saj5OqzhhfGWH1ieEckDJrvY39xqI1Rv752mN6LMzEr0SSeMVug/kmaVhh0eXExuH98SXNd+7Nu
	vfKUkRkwys8Zl1WoraXfUJhMCAqibJu07yniZCtaJIMm/O750+yOxddjctWm+NkdK7BSlq9Ugrd
	8qdLIM5Jgs7u8KYkkhgqh2NPSeasEFGwNdLp/AQDnPJQHJsbZwS599grD6BmxQV0TamJmkOOXt6
	oIVg3KGaqEijcP0guFIALfYMkjY4QnOLpcK15z6r0+ffraP6Dkb5hoO1T8utIfdAIEstzhXQRfk
	JxPGpfrtjohUyIuZ8lfz6TG8i7AOEUA==
X-Google-Smtp-Source: AGHT+IF0s3K/0pM1TTLrWNcjmGYmLGX3vx4si+wUrT0J7FJc8czdl7p5onvVdN6pMQ3ZypglUBm9jQ==
X-Received: by 2002:a05:6870:c03:b0:2d6:103e:e43d with SMTP id 586e51a60fabf-2ffaf4dc3a1mr3998985fac.20.1752694743418;
        Wed, 16 Jul 2025 12:39:03 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:3f28:4161:2162:7ea2])
        by smtp.gmail.com with UTF8SMTPSA id 586e51a60fabf-2ff1129b23dsm3770971fac.22.2025.07.16.12.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 12:39:02 -0700 (PDT)
Date: Wed, 16 Jul 2025 14:39:01 -0500
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: convert clock.c to CLASS/guards
Message-ID: <c0fa6a9b-5000-4a68-a1f1-9dd1a00be998@sabinyo.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Kent Overstreet,

Commit 7ede8fc514bb ("bcachefs: convert clock.c to CLASS/guards")
from Jul 14, 2025 (linux-next), leads to the following Smatch static
checker warning:

	fs/bcachefs/clock.c:24 bch2_io_timer_add()
	warn: double unlock '&clock->timer_lock' (orig line 27)

fs/bcachefs/clock.c
    22 void bch2_io_timer_add(struct io_clock *clock, struct io_timer *timer)
    23 {
--> 24         guard(spinlock)(&clock->timer_lock);
                                ^^^^^^^^^^^^^^^^^
    25 
    26         if (time_after_eq64((u64) atomic64_read(&clock->now), timer->expire)) {
    27                 spin_unlock(&clock->timer_lock);
                                    ^^^^^^^^^^^^^^^^^

This spin_unlock() was accidentally left over when we converted to guard
locks.  It leads to a double unlock.

    28                 timer->fn(timer);
    29                 return;
    30         }
    31 
    32         for (size_t i = 0; i < clock->timers.nr; i++)
    33                 if (clock->timers.data[i] == timer)
    34                         return;
    35 
    36         BUG_ON(!min_heap_push(&clock->timers, &timer, &callbacks, NULL));
    37 }

regards,
dan carpenter
