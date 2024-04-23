import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/data/model/support_ticket_body_model.dart';
import 'package:meditation_app/helper/date_converter.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../../util/assets.dart';

class SupportSectionTicketItem extends StatelessWidget {
  final VoidCallback? onPressed;
  final SupportTicket ticket;

  const SupportSectionTicketItem({
    super.key,
    required AppStyle style,
    this.onPressed,
    required this.ticket,
  }) : _style = style;

  final AppStyle _style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(_style.scaleX(11)),
        decoration: ShapeDecoration(
          color: const Color(0xFF2D251F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_style.scaleX(10)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: _style.scaleX(3), right: _style.scaleX(25)),
              child: SvgPicture.asset(SvgPaths.ticket, width: _style.scaleX(25), fit: BoxFit.fitWidth),
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    ticket.description ?? '',
                    style: _style.text.font(mulishSemiBold600, sizePx: 12.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: _style.scaleX(7.5)),
                  Text(
                    ticket.updatedAt == null ? '' : ticket.updatedAt!.toLocal().toStringFormat2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _style.text.font(
                      mulishMedium500,
                      sizePx: 9,
                      color: const Color(0xFF8A8A8A),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: _style.scaleX(10)),
            MaterialButton(
              onPressed: onPressed,
              visualDensity: const VisualDensity(horizontal: -3, vertical: -2),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_style.scaleX(10)),
                side: BorderSide(color: AppColors.primaryColor, width: _style.scaleX(0.5)),
              ),
              child: Text(
                'View Ticket',
                style: _style.text.font(mulishBold700, sizePx: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
