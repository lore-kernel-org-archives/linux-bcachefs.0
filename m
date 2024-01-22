Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C0D64CF5
	for <linux-bcachefs@vger.kernel.org>; Mon, 22 Jan 2024 17:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705944477; cv=none; b=VLEJ+czB1Nv5PYufLq0Rcbd1XWEN+5dAnVYgRLOEWejLraM4mOjMm76inxSxeIOlHncMP5N9BOISYkDRiiUwY0sh0AjXvEiTBFUqY/0pyJS4mIpv+6nMUuDHI872fCxzMNrm6VLeH8onVq6mMMhNqUPfpF2+DJHpUPfhTwNrN/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705944477; c=relaxed/simple;
	bh=VMp3FysYdPSbT9RzT8L4XckDvOAop32e5dVRJSsDz0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kc5SQ6tmpiHWI9INFlcvXoJRnnc53wNt5A7qJApsrfpOxAWm8/gz0grAXlxNLzMlJjrN4E0YEd65qpLTC0cZC5kjy73VSrKW3qxS9aY+LZgOcsUdvUao8pYVxv11NyPrXTBl1hymQPnrmOzeEbjXRgg173HhrfLTa65YnzlKV74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tuq8FRKX; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tuq8FRKX"
Date: Mon, 22 Jan 2024 12:27:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705944473;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FAzzKUc9Ls0+RwM3zcsfwVU9lOyEbqpFB7DJ25T4JKc=;
	b=Tuq8FRKXJQqZ3fEiFjVzRzyyEM75dY6/5AkXc3GhatYmsppIOGK3Pez1tv71Gb7abaX1Ok
	52AUIyNeGmLE6HweYOM30BwQMqgYAxlDCOMRx2JOGFui2uZnGvJ0WEMTO4CwwKO+R0e+KT
	skknQs6xUtMfY+7ks3G36OYwrzdiD8I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: Better journal tracepoints
Message-ID: <p7f64kdm7bfrbn333e5gqkp3moqujy7mtq4omqcbco7v5vqs55@ztowr2nrolyx>
References: <7120e608-e5c2-4d5c-819d-a9423c7a7262@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7120e608-e5c2-4d5c-819d-a9423c7a7262@moroto.mountain>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 22, 2024 at 05:51:32PM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch ff35f7b3d0cf: "bcachefs: Better journal tracepoints" from
> Jan 15, 2024 (linux-next), leads to the following Smatch static
> checker warning:
> 
> 	fs/bcachefs/journal.c:236 __journal_entry_close()
> 	warn: sleeping in atomic context
> 
> fs/bcachefs/journal.c
>     200 static void __journal_entry_close(struct journal *j, unsigned closed_val, bool trace)
>     201 {
>     202         struct bch_fs *c = container_of(j, struct bch_fs, journal);
>     203         struct journal_buf *buf = journal_cur_buf(j);
>     204         union journal_res_state old, new;
>     205         u64 v = atomic64_read(&j->reservations.counter);
>     206         unsigned sectors;
>     207 
>     208         BUG_ON(closed_val != JOURNAL_ENTRY_CLOSED_VAL &&
>     209                closed_val != JOURNAL_ENTRY_ERROR_VAL);
>     210 
>     211         lockdep_assert_held(&j->lock);
>     212 
>     213         do {
>     214                 old.v = new.v = v;
>     215                 new.cur_entry_offset = closed_val;
>     216 
>     217                 if (old.cur_entry_offset == JOURNAL_ENTRY_ERROR_VAL ||
>     218                     old.cur_entry_offset == new.cur_entry_offset)
>     219                         return;
>     220         } while ((v = atomic64_cmpxchg(&j->reservations.counter,
>     221                                        old.v, new.v)) != old.v);
>     222 
>     223         if (!__journal_entry_is_open(old))
>     224                 return;
>     225 
>     226         /* Close out old buffer: */
>     227         buf->data->u64s                = cpu_to_le32(old.cur_entry_offset);
>     228 
>     229         if (trace_journal_entry_close_enabled() && trace) {
>     230                 struct printbuf pbuf = PRINTBUF;
>     231                 pbuf.atomic++;
>     232 
>     233                 prt_str(&pbuf, "entry size: ");
>     234                 prt_human_readable_u64(&pbuf, vstruct_bytes(buf->data));
>     235                 prt_newline(&pbuf);
> --> 236                 bch2_prt_task_backtrace(&pbuf, current, 1);
>                         ^^^^^^^^^^^^^^^^^^^^^^^
> It looks like bch2_prt_task_backtrace() calls kvmalloc() in
> __bch2_darray_resize() which is a sleeping function.  A lot of of the
> callers are holding spinlocks.
> 
> bch2_journal_halt() <- disables preempt
> bch2_journal_entry_close() <- disables preempt
> bch2_journal_flush_seq_async() <- disables preempt
> -> journal_entry_want_write()
> journal_write_work() <- disables preempt
> __journal_res_get() <- disables preempt
> bch2_journal_entry_res_resize() <- disables preempt
> bch2_journal_flush_seq_async() <- disables preempt <duplicate>
> __bch2_next_write_buffer_flush_journal_buf() <- disables preempt
>    -> __journal_entry_close()
> 
> regards,
> dan carpenter

Thanks - that just needs gfp flags plumbed.
