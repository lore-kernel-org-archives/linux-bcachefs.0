Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C243DB82
	for <linux-bcachefs@vger.kernel.org>; Mon, 22 Jan 2024 14:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705935099; cv=none; b=lybAHAmEvyMZ/PNLXOuztYDyRpv5+ax+lx6kMXD5/cGdvf92oG7OG3OUqY2hQNLVLOzS13SSfqHbuWThnp+d+/Z0RdSRNPNCRaPTBKpJUVwpI1kU0uYhS8JVQjJ5EQSvV2RQuEqOKxHUFqK5qadFVuX8mmMFW1AHw+SLcMJTvxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705935099; c=relaxed/simple;
	bh=KOGxtfpEhnQ7oAZOCqeMvfNeqtxqNcCKjIGY/p2rNvs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UdxNKyrdn3tpDGMYpgNHB+E8ums59XvyLVF5rvWcTxrO+FhEgP+c9Fu+jnNo+8a2Ni61Vp4JF/syrTzFsvzXRCACznbj8xN3G69wniAV1Tz2ywBDprZ5tbRmbSVFZIix5hU79UpKQlU90wSpYNAFwACHM7gV4Lh5kgepgpEUhrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QX0RqMY1; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QX0RqMY1"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-40e9d288f45so38889865e9.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 22 Jan 2024 06:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705935096; x=1706539896; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cfRuzGtnviDBvENKgRtKt9Tq+grP61BoY2wxDNzWV6c=;
        b=QX0RqMY1qo3himbkVdE6spEV/Vdq3G9qkf5UfUY0Y/i0H6MSSV5dw0UzPVzd5gZe0h
         hDZuC3zKpeWZj4ZtNsWYqo6a5Ghkv/QtQuNYoguuuKs14whA9VAP1HpxfFPN2wDApOX+
         mVETgRa/umN6BFAvQFCdunq/uCzKH3KPWiAP4r3JgYU3CKGRiAWsRNiEb2cULcpDyv5G
         kYVCnbScFZKHLHmf4L1y2DB/ewGCooCrmyY9uJEsZnSGE6P27ZNJEkFKzUX+Ev2G3i5B
         Z3/Qfw5l/oVdFU9yLZyoogsVyt4Z9iC38VzDewH15qoPjxps9oAWxiOHRF7kUDC5TEf8
         4RNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705935096; x=1706539896;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cfRuzGtnviDBvENKgRtKt9Tq+grP61BoY2wxDNzWV6c=;
        b=KwrS1G3sgjiT+B31h5wLCA+aYAQZOXmebtIqXcu0OpKD0zwmmDmSR8BM7aD+vDSGDR
         pweyPJ81jw1djHZKXAxK8EFnioNmtnxrBhPaDkERB7F9x7/hTeRv7NJNMPqawNcD8T80
         d/JmTr2XbxwSOZWMWqHNwuW2eQnEav80JciRwpgiPzASCwtqEzjyVbQ0NxXWwUZ/Z2Xx
         gZqAwYXJ7MCiEp86OfLXFa7JqZs3fbODVFJ67+ocF9W83aeiv9AUkhLw4byyxfsqIA1t
         sCjhD9efHgXFzK9UpmJDphWPlYtLFkqt+YTHp/xUTwyQpLtUSkfd3Te2sibJNxKwf+ws
         LIoA==
X-Gm-Message-State: AOJu0YxIb0DF46T+ZqiqqxButcmyvJF2zxdJJas9ljINHxiNTUVIC3dw
	JnnS/EAAdl8I4tUK5wqEf7uo2Ga3K/V5PRumVkO0N2pV0eoD9k7s5+bgziBN/D4=
X-Google-Smtp-Source: AGHT+IH7GS/aoL3nZ2Y5xpqjssU4B0Jln7lFCFTM8ETEVRKgmEYIH/iWUWEoFRYufp5mkDWnRnEpcw==
X-Received: by 2002:a05:600c:35c2:b0:40e:95b9:2e30 with SMTP id r2-20020a05600c35c200b0040e95b92e30mr1643398wmq.42.1705935096227;
        Mon, 22 Jan 2024 06:51:36 -0800 (PST)
Received: from localhost ([102.140.209.237])
        by smtp.gmail.com with ESMTPSA id l13-20020a05600c4f0d00b0040e85f86515sm21469501wmq.29.2024.01.22.06.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 06:51:35 -0800 (PST)
Date: Mon, 22 Jan 2024 17:51:32 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org
Subject: [bug report] bcachefs: Better journal tracepoints
Message-ID: <7120e608-e5c2-4d5c-819d-a9423c7a7262@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Kent Overstreet,

The patch ff35f7b3d0cf: "bcachefs: Better journal tracepoints" from
Jan 15, 2024 (linux-next), leads to the following Smatch static
checker warning:

	fs/bcachefs/journal.c:236 __journal_entry_close()
	warn: sleeping in atomic context

fs/bcachefs/journal.c
    200 static void __journal_entry_close(struct journal *j, unsigned closed_val, bool trace)
    201 {
    202         struct bch_fs *c = container_of(j, struct bch_fs, journal);
    203         struct journal_buf *buf = journal_cur_buf(j);
    204         union journal_res_state old, new;
    205         u64 v = atomic64_read(&j->reservations.counter);
    206         unsigned sectors;
    207 
    208         BUG_ON(closed_val != JOURNAL_ENTRY_CLOSED_VAL &&
    209                closed_val != JOURNAL_ENTRY_ERROR_VAL);
    210 
    211         lockdep_assert_held(&j->lock);
    212 
    213         do {
    214                 old.v = new.v = v;
    215                 new.cur_entry_offset = closed_val;
    216 
    217                 if (old.cur_entry_offset == JOURNAL_ENTRY_ERROR_VAL ||
    218                     old.cur_entry_offset == new.cur_entry_offset)
    219                         return;
    220         } while ((v = atomic64_cmpxchg(&j->reservations.counter,
    221                                        old.v, new.v)) != old.v);
    222 
    223         if (!__journal_entry_is_open(old))
    224                 return;
    225 
    226         /* Close out old buffer: */
    227         buf->data->u64s                = cpu_to_le32(old.cur_entry_offset);
    228 
    229         if (trace_journal_entry_close_enabled() && trace) {
    230                 struct printbuf pbuf = PRINTBUF;
    231                 pbuf.atomic++;
    232 
    233                 prt_str(&pbuf, "entry size: ");
    234                 prt_human_readable_u64(&pbuf, vstruct_bytes(buf->data));
    235                 prt_newline(&pbuf);
--> 236                 bch2_prt_task_backtrace(&pbuf, current, 1);
                        ^^^^^^^^^^^^^^^^^^^^^^^
It looks like bch2_prt_task_backtrace() calls kvmalloc() in
__bch2_darray_resize() which is a sleeping function.  A lot of of the
callers are holding spinlocks.

bch2_journal_halt() <- disables preempt
bch2_journal_entry_close() <- disables preempt
bch2_journal_flush_seq_async() <- disables preempt
-> journal_entry_want_write()
journal_write_work() <- disables preempt
__journal_res_get() <- disables preempt
bch2_journal_entry_res_resize() <- disables preempt
bch2_journal_flush_seq_async() <- disables preempt <duplicate>
__bch2_next_write_buffer_flush_journal_buf() <- disables preempt
   -> __journal_entry_close()

regards,
dan carpenter
